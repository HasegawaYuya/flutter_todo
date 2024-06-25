import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'やることリスト'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _todoList = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add({'title': title, 'done': false});
    });
    _textController.clear();
  }

  void _editTodoItem(int index, String newTitle) {
    setState(() {
      _todoList[index]['title'] = newTitle;
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  void _clearCompletedTodos() {
    setState(() {
      _todoList.removeWhere((todo) => todo['done']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearCompletedTodos,
            tooltip: '完了済みを削除',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                final todo = _todoList[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo['done'],
                    onChanged: (bool? value) {
                      setState(() {
                        todo['done'] = value ?? false;
                      });
                    },
                  ),
                  title: GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final editController = TextEditingController(text: todo['title']);
                          return AlertDialog(
                            title: const Text('TODOを編集'),
                            content: TextField(
                              controller: editController,
                              autofocus: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('キャンセル'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _editTodoItem(index, editController.text);
                                  Navigator.pop(context);
                                },
                                child: const Text('更新'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      todo['title'],
                      style: TextStyle(
                        decoration: todo['done'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeTodoItem(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _todoList.clear();
                });
              },
              child: const Text('全て削除'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('TODOを追加'),
                content: TextField(
                  controller: _textController,
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addTodoItem(_textController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('追加'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add TODO',
        child: const Icon(Icons.add),
      ),
    );
  }
}
