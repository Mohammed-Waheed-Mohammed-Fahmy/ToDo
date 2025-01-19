import 'dart:convert';
import 'dart:core';

import '../utils/status.dart';

class TodoItem {
  int? id;
  String todo;
  String description;
  Status status;
  DateTime deadline;

  TodoItem(
      {this.id,
      required this.description,
      required this.todo,
      required this.deadline,
      required this.status});

  String parseToString() {
    return '{"id": "$id","todo": "$todo","description": "$description","deadline": "$deadline","status": "${status.label}"}';
  }

  Map<String, Object?> toJson() => {
        TodoItemFields.id: id,
        TodoItemFields.todo: todo,
        TodoItemFields.description: description,
        TodoItemFields.status: status.label,
        TodoItemFields.deadline: deadline.toIso8601String()
      };

  static TodoItem parseFromString(String itemString) {
    var data = jsonDecode(itemString);
    int id = int.parse(data["id"]);
    String todo = data["todo"];
    String description = data["description"];
    String deadlineString = data["deadline"];
    String statusString = data["status"];

    DateTime time = DateTime.parse(deadlineString);

    Status status = Status.values.firstWhere((s) => statusString == s.label);

    return TodoItem(
        id: id,
        description: description,
        todo: todo,
        deadline: time,
        status: status);
  }

  factory TodoItem.fromJson(Map<String, Object?> json) => TodoItem(
      id: json[TodoItemFields.id] as int,
      description: json[TodoItemFields.description] as String,
      todo: json[TodoItemFields.todo] as String,
      deadline: DateTime.parse(json[TodoItemFields.deadline] as String),
      status: Status.parse(json[TodoItemFields.status] as String));
}

class TodoItemFields {
  static const String tableName = "todo_items";
  static const String id = "id";
  static const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
  static const String todo = "todo";
  static const String todoType = "TEXT NOT NULL";
  static const String description = "description";
  static const String descriptionType = "TEXT NOT NULL";
  static const String status = "status";
  static const String statusType = "TEXT NOT NULL";
  static const String deadline = "deadline";
  static const String deadlineType = "TEXT NOT NULL";
}
