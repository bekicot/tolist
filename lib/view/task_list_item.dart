import 'package:flutter/material.dart';
import 'package:tolist/models/task.dart';

class TaskListItemView extends StatefulWidget {
  final Task task;
  @override
  State<StatefulWidget> createState() {
    return TaskListItemState(task);
  }

  TaskListItemView(this.task);
}

class TaskListItemState extends State<TaskListItemView> {
  bool _val = false;
  final Task task;

  TaskListItemState(Task this.task);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(task.content),
      controlAffinity: ListTileControlAffinity.leading,
      value: task.status == TASK_DONE,
      onChanged: (val) {
        setState(() {
          task.toggleStatus();
        });
      },
    );;
  }
}