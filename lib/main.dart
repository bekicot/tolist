import 'package:tolist/view/task_list.dart';
import 'package:flutter/material.dart';

import 'models/db.dart';
import 'models/task.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To List",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppContentState();
  }
}

enum _AppContentStates {
  ADDING_TASK, IDLE
}
class AppContentState extends State<AppContent> {
  _AppContentStates state= _AppContentStates.IDLE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
  _showAddTaskForm(BuildContext buildContext) {
    return () async {
      setState(() => state = _AppContentStates.ADDING_TASK);
    };
  }

  _bodyBuilder() {
    if(state == _AppContentStates.ADDING_TASK) {
      return Stack(
          children: <Widget>[
            TaskListView(),
            Row(children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  // TODO: Save it to db onEditingComplete
                  child: AddTaskWidget(() {
                    setState(() {
                      state = _AppContentStates.IDLE;
                    });
                  }),
                ),
              )
            ],)
          ]
      );
    } else {
      return TaskListView();
    }
  }
}

class AddTaskWidget extends StatelessWidget {
  final controller = TextEditingController();
  final Function _onEditingComplete;
  final db = DB();
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      onEditingComplete: () {
        final task = Task(content: controller.text);
        db.addTask(task);
        _onEditingComplete();
      },
    );
  }

  AddTaskWidget(this._onEditingComplete);

}
