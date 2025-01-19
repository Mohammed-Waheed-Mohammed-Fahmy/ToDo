import 'package:assignment_todo/database/storage-manager.dart';
import 'package:assignment_todo/business/todo_item.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteStorageManager implements StorageManager {
  static final SQLiteStorageManager _instance =
      SQLiteStorageManager._internal();

  factory SQLiteStorageManager() => _instance;

  static Database? _database;

  SQLiteStorageManager._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/notes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${TodoItemFields.tableName} (
          ${TodoItemFields.id} ${TodoItemFields.idType}, 
          ${TodoItemFields.todo} ${TodoItemFields.todoType}, 
          ${TodoItemFields.description} ${TodoItemFields.descriptionType}, 
          ${TodoItemFields.status} ${TodoItemFields.statusType}, 
          ${TodoItemFields.deadline} ${TodoItemFields.deadlineType}
          )
        ''');
  }

  @override
  Future<void> updateTodo(TodoItem todo) async {
    final db = await _instance.database;
    db.update(TodoItemFields.tableName, todo.toJson(),
        where: "${TodoItemFields.id} = ?", whereArgs: [todo.id]);
  }

  @override
  Future<TodoItem> addTodo(TodoItem todo) async {
    final db = await _instance.database;
    int id = await db.insert(TodoItemFields.tableName, todo.toJson());
    todo.id = id;
    return todo;
  }

  @override
  Future<List<TodoItem>> retrieveAllTodos() async {
    final db = await _instance.database;
    final result = await db.query(TodoItemFields.tableName);
    return result.map((json) => TodoItem.fromJson(json)).toList();
  }

  @override
  Future<void> removeTodo(int id) async {
    final db = await _instance.database;
    db.delete(TodoItemFields.tableName,
        where: "${TodoItemFields.id} = ?", whereArgs: [id]);
  }
}
