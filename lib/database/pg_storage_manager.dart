import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/database/storage-manager.dart';
import 'package:postgres/postgres.dart';

class PGStorageManager implements StorageManager {
  Endpoint pgEndpoint = Endpoint(
    host: const String.fromEnvironment("PG_HOST", defaultValue: "localhost"),
    port: int.tryParse(
            const String.fromEnvironment("PG_PORT", defaultValue: "5432")) ??
        5432,
    database: const String.fromEnvironment("PG_DATABASE_NAME",
        defaultValue: "default_db"),
    username:
        const String.fromEnvironment("PG_USERNAME", defaultValue: "postgres"),
    password:
        const String.fromEnvironment("PG_PASSWORD", defaultValue: "password"),
  );

  @override
  Future<TodoItem> addTodo(TodoItem todo) async {
    Connection conn = await Connection.open(
      pgEndpoint,
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    final insertResult = await conn.execute(
        "INSERT INTO ${TodoItemFields.tableName}"
        "(todo, description, status, deadline) "
        r"VALUES ($1, $2, $3, $4) RETURNING id",
        parameters: [
          todo.todo,
          todo.description,
          todo.status.label,
          todo.deadline.toIso8601String()
        ]);

    final id = insertResult.first[0];

    final selectResult = await conn.execute(
        "SELECT * FROM ${TodoItemFields.tableName} WHERE" r" id = $1",
        parameters: [id]);

    conn.close();
    return TodoItem.fromJson(selectResult.first.toColumnMap());
  }

  @override
  Future<void> removeTodo(int id) async {
    Connection conn = await Connection.open(
      pgEndpoint,
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    await conn.execute(
        "DELETE FROM ${TodoItemFields.tableName} WHERE" r" id = $1",
        parameters: [id]);
    conn.close();
  }

  @override
  Future<List<TodoItem>> retrieveAllTodos() async {
    Connection conn = await Connection.open(
      pgEndpoint,
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    final Result result =
        await conn.execute("SELECT * FROM ${TodoItemFields.tableName}");
    conn.close();
    return result.map((row) => TodoItem.fromJson(row.toColumnMap())).toList();
  }

  @override
  Future<void> updateTodo(TodoItem todo) async {
    Connection conn = await Connection.open(
      pgEndpoint,
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    await conn.execute(
        Sql.named(
            "UPDATE ${TodoItemFields.tableName} SET todo = @todo, description = @description, status = @status, deadline = @deadline WHERE id = @id"),
        parameters: {
          "todo": todo.todo,
          "description": todo.description,
          "status": todo.status.label,
          "deadline": todo.deadline.toIso8601String(),
          "id": todo.id
        });
    conn.close();
  }
}
