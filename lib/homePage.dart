import 'package:flutter/material.dart';
import 'package:todo_hive/data/database.dart';
import 'utils/todo_tile.dart';
import 'utils/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _myBox = Hive.box('myBox');
  final _controller = TextEditingController();
  ToDoDatabase db = ToDoDatabase();
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todo[index][1] = !db.todo[index][1];
    });
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void saveNewTask() {
    setState(() {
      db.todo.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
    setState(() {
      db.todo.removeAt(index);
    });
    db.updateData();
  }

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff9f9e9e),
      appBar: AppBar(
        title: Text(
          'TO DO',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todo.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todo[index][0],
            taskCompleted: db.todo[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
