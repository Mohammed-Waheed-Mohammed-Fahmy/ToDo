import 'dart:convert';

import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/database/storage-manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorageManager implements StorageManager {
  final todoKey = "todos";

  Future<SharedPreferences> get _prefs async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(todoKey) == null) {
      preferences.setString(todoKey, "[]");
    }
    return preferences;
  }

  @override
  Future<TodoItem> addTodo(TodoItem todo) async {
    SharedPreferences preferences = await _prefs;
    final String prefContent = preferences.getString(todoKey)!;

    final List<dynamic> fileJson = jsonDecode(prefContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    todo.id = DateTime.now().millisecondsSinceEpoch;
    todoList.add(todo);

    preferences.setString(todoKey, jsonEncode(todoList));

    return todo;
  }

  @override
  Future<void> removeTodo(int id) async {
    SharedPreferences preferences = await _prefs;
    final String prefContent = preferences.getString(todoKey)!;

    final List<dynamic> fileJson = jsonDecode(prefContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    todoList.removeWhere((todo) => todo.id == id);

    preferences.setString(todoKey, jsonEncode(todoList));
  }

  @override
  Future<List<TodoItem>> retrieveAllTodos() async {
    SharedPreferences preferences = await _prefs;
    final String prefContent = preferences.getString(todoKey)!;

    final List<dynamic> fileJson = jsonDecode(prefContent);

    return fileJson.map((todo) => TodoItem.fromJson(todo)).toList();
  }

  @override
  Future<void> updateTodo(TodoItem todo) async {
    SharedPreferences preferences = await _prefs;
    final String prefContent = preferences.getString(todoKey)!;

    final List<dynamic> fileJson = jsonDecode(prefContent);

    List<TodoItem> todoList =
        fileJson.map((todo) => TodoItem.fromJson(todo)).toList();

    final todoToUpdate = todoList.firstWhere((t) => t.id == todo.id);
    final todoToUpdateIndex = todoList.indexOf(todoToUpdate);

    todoToUpdate.todo = todo.todo;
    todoToUpdate.description = todo.description;
    todoToUpdate.status = todo.status;
    todoToUpdate.deadline = todo.deadline;

    todoList.replaceRange(todoToUpdateIndex, todoToUpdateIndex, [todoToUpdate]);

    preferences.setString(todoKey, jsonEncode(todoList));
  }
}
