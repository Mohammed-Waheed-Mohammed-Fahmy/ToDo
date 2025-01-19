import 'package:assignment_todo/presentation/todo_page_headerline.dart';
import 'package:flutter/material.dart';
import '../presentation/todo_add_modal.dart';
import '../presentation/todo_list.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M.W',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(8.0), // Padding inside the dropdown menu
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: TodoAppPage(title: 'M.W'),
    );
  }
}

class TodoAppPage extends StatelessWidget {
  TodoAppPage({super.key, required this.title});

  final String title;

  final TextEditingController _controller =
      TextEditingController(text: "default");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // Custom height for AppBar
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(16.0), // Round the bottom left corner
                bottomRight:
                    Radius.circular(16.0), // Round the bottom right corner
              ),
              child: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(title),
                centerTitle: true,
              ),
            )),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TodoAppHeaderLine(),
                TodoList(),
              ]),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TodoAddModalFloatingButton(),
          ],
        ));
  }
}
