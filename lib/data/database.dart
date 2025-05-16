import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  final _myBox = Hive.box('myBox');
  List todo = [];
  void createInitialData() {
    todo = [
      ['Hive', false],
      ['database', false]
    ];
  }

  void loadData() {
    todo = _myBox.get('TODOLIST');
  }

  void updateData() {
    _myBox.put("TODOLIST", todo);
  }
}
