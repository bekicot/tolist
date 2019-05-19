import 'package:flutter/material.dart';
import 'package:tolist/models/db.dart';
import 'package:tolist/view/task_list_item.dart';
import 'dart:async';
import '../models/task.dart';

class TaskListView extends StatefulWidget {
  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskListView> {
  StreamController<Task> streamController = StreamController.broadcast();
  List<Task> tasks;
  DB db = DB();
  @override
  void initState() {
    super.initState();
    streamController.stream.listen(
            (task) => setState(() => { tasks.add(task) })
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.tasksStream,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        return ListView(
            children: [..._taskListView(snapshot.data)]
        );
      },
    );
  }

  List<Widget> _taskListView(List<Task> data) {
    if(data == null) return [];
    return data.map((task) {
      return TaskListItemView(task);
    }).toList();
  }
}
