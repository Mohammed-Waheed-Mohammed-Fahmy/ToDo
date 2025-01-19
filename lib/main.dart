import 'package:assignment_todo/database/pg_storage_manager.dart';
import 'package:assignment_todo/business/todo_list_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/todo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PGStorageManager();

  runApp(ChangeNotifierProvider(
    create: (context) => TodoListManager(),
    child: const TodoApp(),
  ));
}
