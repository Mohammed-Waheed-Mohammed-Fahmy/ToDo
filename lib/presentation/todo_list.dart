import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/business/todo_list_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/status.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Consumer<TodoListManager>(
            builder: (context, itemListManager, child) => ListView(
                padding: const EdgeInsets.only(bottom: 90, top: 10),
                children: List<Widget>.from(
                    itemListManager.todoList.values.map((todo) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      title: TodoListTitle(todo: todo),
                      children: [TodoListDetailed(todo: todo)],
                    ),
                  );
                })))));
  }
}

class TodoListDetailed extends StatelessWidget {
  const TodoListDetailed({super.key, required this.todo});

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListManager>(
        builder: (context, itemListManager, child) => Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Deadline:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${todo.deadline.day}/${todo.deadline.month}/${todo.deadline.year}")
                        ],
                      ),
                      DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: todo.status,
                              items: Status.values.map((Status status) {
                                return DropdownMenuItem<Status>(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: status.color,
                                        size: 14,
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(status.label))
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (Status? status) {
                                if (status != null) {
                                  itemListManager.changeTodoStatus(
                                      todo.id!, status);
                                }
                              }))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Text(
                        "Description:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    Text(
                      todo.description,
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red)),
                              onPressed: () =>
                                  itemListManager.removeTodoItem(todo.id!),
                              child: const Row(
                                children: [Icon(Icons.delete), Text("Delete")],
                              ))
                        ])),
              ],
            )));
  }
}

class TodoListTitle extends StatelessWidget {
  const TodoListTitle({super.key, required this.todo});

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 14,
                  color: todo.status.color,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      todo.status.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ))
              ],
            ),
            todo.status != Status.done
                ? Row(
                    children: [
                      const Text(
                        "Due in ",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14),
                      ),
                      Text(
                        todo.deadline
                            .difference(DateTime.now())
                            .inDays
                            .toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Text(
                        " days.",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
      Text(todo.todo,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: todo.status == Status.done
                  ? TextDecoration.lineThrough
                  : null))
    ]);
  }
}
