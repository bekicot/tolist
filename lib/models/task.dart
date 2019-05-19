
// Statuses
import 'package:sqflite/sqlite_api.dart';

import 'db.dart';
import 'model.dart';

const TASK_DONE = 1;
const TASK_NOT_DONE = 0;

class Task {
  final String id;
  String content;
  int status;
  String tags;

  Future<bool> update({
    content = ARGUMENT.EMPTY,
    status = ARGUMENT.EMPTY,
    tags = ARGUMENT.EMPTY}) async {
//    var properties = <String>[];
//    var values = [];

    Map<String, dynamic> updates = {};

    if(content != ARGUMENT.EMPTY) {
//      properties.add("content");
//      values.add(content);
      updates["content"] = content;
    }
    if(status != ARGUMENT.EMPTY) {
//      properties.add("status");
//      values.add(status);
      updates["status"] = status;
    }

    if(tags != ARGUMENT.EMPTY) {
//      properties.add("tags");
//      values.add(tags);
      updates["tags"] = tags;
    }

//    _insert("tasks", properties, values);
    _update("tasks", updates);
  }
  
  Task({this.id, this.content, this.status = TASK_NOT_DONE, this.tags});

  Future<int> toggleStatus () async {
    if(this.status == TASK_DONE) {
      this.status = TASK_NOT_DONE;
    } else {
      this.status = TASK_DONE;
    }
    await update(status: this.status);
    return this.status;
  }

  Future<int> _update(String table, Map<String, dynamic> updates) async {
    final db = await DB().sqlite;
    // TODO Update is not persisted
    // Mungkin CHeck logsnya
    return db.update(table, updates, where: "id = '$id'");
  }
}