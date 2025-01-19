import 'package:assignment_todo/business/todo_list_manager.dart';
import 'package:assignment_todo/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoAddModalFloatingButton extends StatelessWidget {
  TodoAddModalFloatingButton({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Click to add a Todo!",
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: const Text("Enter a Todo:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    ),
                    const TodoModalFormState()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TodoModalFormState extends StatefulWidget {
  const TodoModalFormState({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoModalForm();
  }
}

class TodoModalForm extends State<TodoModalFormState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _todoController.dispose();
    _descController.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (date != null) {
      setState(() {
        _dateController.text = date.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _todoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fillColor: Colors.white,
                  hintText: 'Enter your Todo',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  fillColor: Colors.white,
                  hintText: 'Enter a description',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.calendar_today),
                hintText: 'Select a deadline',
              ),
              readOnly: true,
              onTap: () => _selectDate(),
            ),
            TodoAddModalButtons(
              formKey: formKey,
              todo: _todoController.text,
              description: _descController.text,
              deadline: _dateController.text,
            )
          ],
        ));
  }
}

class TodoAddModalTextField extends StatelessWidget {
  final TextEditingController controller;

  const TodoAddModalTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}

class TodoAddModalButtons extends StatelessWidget {
  const TodoAddModalButtons(
      {super.key,
      required this.todo,
      required this.formKey,
      required this.description,
      required this.deadline});

  final GlobalKey<FormState> formKey;

  final String todo;
  final String description;
  final String deadline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer),
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
        Consumer<TodoListManager>(
            builder: (context, todoItemManager, child) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text('Add'),
                  onPressed: () => {
                    if (formKey.currentState!.validate())
                      {
                        todoItemManager.addTodoItem(todo, description,
                            Status.open, DateTime.parse(deadline)),
                        Navigator.pop(context),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            content: const Text('ToDo added!')))
                      }
                  },
                ))
      ]),
    );
  }
}
