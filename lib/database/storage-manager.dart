import 'package:assignment_todo/business/todo_item.dart';

abstract class StorageManager {
  Future<TodoItem> addTodo(TodoItem todo);

  Future<void> removeTodo(int id);

  Future<void> updateTodo(TodoItem todo);

  Future<List<TodoItem>> retrieveAllTodos();
}
