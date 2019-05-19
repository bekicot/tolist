import 'dart:async';

import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tolist/models/task.dart';


const CREATE_TASKS_TABLE = """
create table if not exists tasks(
  id CHAR(36) default (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
  content varchar DEFAULT(''),
  status INTEGER DEFAULT(0),
  tags TEXT DEFAULT(''),
  PRIMARY KEY ("id")
)
""";

class DB {
  static final DB database = new DB._internal();
  List<Task> tasks = [];
  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject<List<Task>>.seeded([]);
  final StreamController<Task> _taskSC = StreamController<Task>();
  Database _sqlite;

  Future<Database> get sqlite async {
    if(_sqlite != null) return _sqlite;
    Sqflite.devSetDebugModeOn(true);

    final databasePath = join(await getDatabasesPath(), 'tasks.db');
    _sqlite = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(CREATE_TASKS_TABLE);
        }
    );
    await _syncTasks();
    return _sqlite;
  }
  StreamSink<Task> get _tasksSink => _taskSC.sink;
  Stream<List<Task>> get tasksStream => _tasks.stream;

  factory DB() {
    return database;
  }

  addTask(Task task) async {
    var db = await sqlite;
    await db.insert("tasks", { 'content': task.content });
    print(await db.query("sqlite_master"));
    _tasksSink.add(task);
  }

  _syncTasks() async {
    var db = await sqlite;
    var rawTasks = await db.query("tasks");
    List<Task> tasksTemp = [];
    rawTasks.forEach((t) => tasksTemp.add(
        Task(
          id: t["id"],
          content: t["content"],
          status: t["status"],
          tags: t["tags"],
        )
    ));
    tasks = tasksTemp;
    _tasks.add(tasks);
  }

  DB._internal() {
//    initialize Sqlite
    sqlite;
    _taskSC.stream.listen((task) {
      tasks.add(task);
      _tasks.add(tasks);
    });
  }
}
