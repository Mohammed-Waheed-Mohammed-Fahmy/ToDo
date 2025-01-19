import 'dart:convert';
import 'dart:io';

import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/database/storage-manager.dart';
import 'package:path_provider/path_provider.dart';

class PathProviderStorageManager implements StorageManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File file = File('$path/todos.json');
    if (!file.existsSync()) {
      file = await file.create();
      file = await file.writeAsString("[]");
    }
    return file;
  }

  @override
  Future<TodoItem> addTodo(TodoItem todo) async {
    File todoFile = await _localFile;
    final String fileContent = await todoFile.readAsString();

    final List<dynamic> fileJson = jsonDecode(fileContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    todo.id = DateTime.now().millisecondsSinceEpoch;
    todoList.add(todo);

    todoFile.writeAsString(jsonEncode(todoList));

    return todo;
  }

  @override
  Future<void> removeTodo(int id) async {
    File todoFile = await _localFile;
    final String fileContent = await todoFile.readAsString();

    final List<dynamic> fileJson = jsonDecode(fileContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    todoList.removeWhere((todo) => todo.id == id);

    todoFile.writeAsString(jsonEncode(todoList));
  }

  @override
  Future<List<TodoItem>> retrieveAllTodos() async {
    File todoFile = await _localFile;
    final String fileContent = await todoFile.readAsString();

    final List<dynamic> fileJson = jsonDecode(fileContent);

    return fileJson.map((todo) => TodoItem.fromJson(todo)).toList();
  }

  @override
  Future<void> updateTodo(TodoItem todo) async {
    File todoFile = await _localFile;
    final String fileContent = await todoFile.readAsString();

    final List<dynamic> fileJson = jsonDecode(fileContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    final todoToUpdate = todoList.firstWhere((t) => t.id == todo.id);
    final todoToUpdateIndex = todoList.indexOf(todoToUpdate);

    todoToUpdate.todo = todo.todo;
    todoToUpdate.description = todo.description;
    todoToUpdate.status = todo.status;
    todoToUpdate.deadline = todo.deadline;

    todoList.replaceRange(todoToUpdateIndex, todoToUpdateIndex, [todoToUpdate]);

    todoFile.writeAsString(jsonEncode(todoList));
  }
}
