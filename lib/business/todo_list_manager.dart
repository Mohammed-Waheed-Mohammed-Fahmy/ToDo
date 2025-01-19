import 'package:assignment_todo/database/path_provider_storage_manager.dart';
import 'package:assignment_todo/database/pg_storage_manager.dart';
import 'package:assignment_todo/database/shared_prefs_storage_manager.dart';
import 'package:assignment_todo/database/sqlite-storage-manager.dart';
import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/database/storage-manager.dart';
import 'package:assignment_todo/utils/sort_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../utils/status.dart';

class TodoListManager extends ChangeNotifier {
  final StorageManager storageManager =
      kIsWeb ? SharedPrefsStorageManager() : PathProviderStorageManager();

  TodoListManager() {
    _loadInitialData();
    print(storageManager);
  }

  Map<int, TodoItem> _todoMap = {};
  SortValues _currentSorting = SortValues.defaultState;

  Map<int, TodoItem> get todoList => _todoMap;

  SortValues get currentSorting => _currentSorting;

  addTodoItem(
      String todo, String description, Status status, DateTime deadline) async {
    TodoItem item = TodoItem(
        description: description,
        todo: todo,
        deadline: deadline,
        status: status);

    item = await storageManager.addTodo(item);

    _todoMap[item.id!] = item;

    notifyListeners();
  }

  removeTodoItem(int id) {
    _todoMap.remove(id);
    storageManager.removeTodo(id);
    notifyListeners();
  }

  changeTodoStatus(int id, Status newStatus) {
    TodoItem? item = _todoMap[id];
    item?.status = newStatus;

    if (item != null) {
      _todoMap[id] = item;
      storageManager.updateTodo(item);
    }

    notifyListeners();
  }

  sortTodosByTyp(SortValues value) {
    switch (value) {
      case SortValues.todo:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) => a.value.todo.compareTo(b.value.todo)));
      case SortValues.deadline:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) {
            if (a.value.status == Status.done &&
                b.value.status != Status.done) {
              return 1;
            }
            if (b.value.status == Status.done &&
                a.value.status != Status.done) {
              return -1;
            }
            return a.value.deadline.compareTo(b.value.deadline);
          }));
      case SortValues.status:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) {
            if (a.value.status == Status.done &&
                b.value.status != Status.done) {
              return 1;
            }
            if (b.value.status == Status.done &&
                a.value.status != Status.done) {
              return -1;
            }
            return a.value.status.compareTo(b.value.status);
          }));
      case SortValues.defaultState:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) => a.value.id!.compareTo(b.value.id!)));
    }
    notifyListeners();
    _currentSorting = value;
  }

  Future<void> _loadInitialData() async {
    final data = await storageManager.retrieveAllTodos();
    for (var todo in data) {
      _todoMap[todo.id!] = todo;
    }
    notifyListeners();
  }
}
