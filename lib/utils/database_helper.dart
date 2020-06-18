import 'dart:async';
import 'dart:io';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tabletask = "todoTable";
  final String columnId = "id";
  final String columnname = "name";
  final String columndate = "date";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "tododb.db"); //home://directory/files/tododb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tabletask($columnId INTEGER PRIMARY KEY, $columnname TEXT, $columndate TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE , DELETE

  //Insertion
  Future<int> saveTask(Task task) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tabletask", task.toMap());
    return res;
  }

  //Get tasks
  Future<List> getAlltasks() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tabletask");
    // ORDER BY $columnname ASC

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tabletask"));
  }

  Future<Task> gettask(int id) async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery("SELECT * FROM $tabletask WHERE $columnId = $id");
    if (result.length == 0) return null;
    return new Task.fromMap(result.first);
  }

  Future<int> deletetask(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tabletask, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updatetask(Task task) async {
    var dbClient = await db;
    return await dbClient.update(tabletask, task.toMap(),
        where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
