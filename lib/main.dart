import 'package:flutter/material.dart';
import 'package:todo_list_app/styles/colors.dart';
import 'package:todo_list_app/styles/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final GlobalKey<_TodoListState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To Do List",
          style: appBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: appBarcolor,
        elevation: 0,
      ),
      body: TodoList(key: _key),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Вы уверены?'),
                content:
                    const Text('Это действие удалит все задачи из списка.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // Отмена
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // Подтверждение
                    child: const Text('Да'),
                  ),
                ],
              );
            },
          );
          if (confirmed == true) {
            _key.currentState?.clearAll();
          }
        },
        tooltip: 'Clear all tasks',
        backgroundColor: const Color.fromARGB(255, 235, 130, 122),
        child: const Icon(Icons.delete_sweep, color: Colors.white),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class Job {
  final String name;
  bool done;

  Job({required this.name, this.done = false});
}

class _TodoListState extends State<TodoList> {
  final myController = TextEditingController();
  final jobList = <Job>[];

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void add() {
    if (myController.text.isEmpty) return; // Не добавлять пустые задачи
    setState(() {
      jobList.add(Job(name: myController.text));
    });
    myController.clear();
  }

  void remove(Job job) {
    setState(() {
      jobList.remove(job);
    });
  }

  void toggleDone(Job job) {
    setState(() {
      job.done = !job.done; // Переключение статуса (можно отменить)
    });
  }

  void clearAll() {
    setState(() {
      jobList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: appBarcolor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Enter new job',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Горизонтальный отступ
                ElevatedButton(
                  onPressed: add,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 45, // Уменьшил размер для баланса
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            color: Colors.white, // Белый фон для списка задач
            child: ListView.builder(
              itemCount: jobList.length,
              itemBuilder: (context, index) {
                final job = jobList[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                toggleDone(job), // Tap для переключения Done
                            child: Text(
                              job.name,
                              style: TextStyle(
                                fontSize: 20,
                                decoration: job.done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(40, 40),
                                backgroundColor: Colors.green,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed:
                                  job.done ? null : () => toggleDone(job),
                              child: const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(40, 40),
                                backgroundColor: Colors.red,
                                side: BorderSide
                                    .none, // Убрать рамку для сплошного цвета
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => remove(job),
                              child: const Icon(
                                Icons.delete_forever,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
