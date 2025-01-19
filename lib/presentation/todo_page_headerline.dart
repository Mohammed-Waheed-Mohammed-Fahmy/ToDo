import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/todo_list_manager.dart';
import '../utils/sort_values.dart';

class TodoAppHeaderLine extends StatelessWidget {
  const TodoAppHeaderLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Todos:",
            style: TextStyle(
              backgroundColor: Colors.transparent,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Row(children: [
            const Text(
              "Sort by:   ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Consumer<TodoListManager>(
                builder: (context, todoListManager, child) {
              return DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: todoListManager.currentSorting,
                    items: SortValues.values.map((val) {
                      return DropdownMenuItem<SortValues>(
                          value: val,
                          child: Text(val.label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200)));
                    }).toList(),
                    onChanged: (val) {
                      todoListManager.sortTodosByTyp(val!);
                    }),
              );
            })
          ])
        ],
      ),
    );
  }
}
