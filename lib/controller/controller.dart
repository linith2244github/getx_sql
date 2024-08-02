import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/todo_model.dart';

class SQLController extends GetxController {
  @override
  void onInit() {
    createDatabase();
    super.onInit();
  }

  late Database database;
  void createDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    openAppDatabase(path: path);
  }

  void deleteTheDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    await deleteDatabase(path);
  }

  void openAppDatabase({required String path}) async {
    // open the database
    await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      // todo => is our table name / primary key increment auto
      await db.execute(
          'CREATE TABLE todo (id INTEGER PRIMARY KEY, title TEXT, description TEXT, time TEXT, favorite INTEGER, completed INTEGER)');
      debugPrint('database is created');
    }, onOpen: (Database db) {
      database = db;
      getAllData();
      debugPrint('database is opened');
    });
  }

  List<TodoModel> list = [];
  List<TodoModel> favList = [];

  void getAllData() async {
    list = [];
    favList = [];
    var allData = await database.query('todo');
    for (var i in allData) {
      // debugPrint(i.toString());
      list.add(TodoModel.fromJson(i));
      if(i['favorite'] == 1){
        favList.add(TodoModel.fromJson(i));
      }
    }
    // debugPrint(allData.toString());
    update();
    // debugPrint(favList.toString());
  }

  void insertData({
    required String title,
    required String description,
    required String time,
  }) async {
    try {
      var insert = await database.insert('todo', {
        'title': title,
        'description': description,
        'time': time,
        'favorite': 0,
        'completed': 0,
      });
      debugPrint('$insert data inserted');
      getAllData();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool updateTaskData = false;

  void updateData({
    required int id,
    required String title,
    required String description,
    required String time,
  }) async {
    try {
      var updateData = await database.update(
        'todo',
        {
          'title': title,
          'description': description,
          'time': time,
          'favorite': 1,
          'completed': 1,
        },
        where: "id = $id",
      );
      debugPrint("Updated Item ${updateData.toString()}");
      getAllData();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteData({required int id}) async {
    var deleteItem = await database.delete('todo', where: 'id = $id');
    debugPrint('deleted item $deleteItem');
    getAllData();
    Get.back();
  }

  void updateItemIntoFav({required int taskId, required int favorite}) async {
    var favoriteItem = await database.update(
        'todo', {'favorite': (favorite == 0) ? 1 : 0},
        where: 'id = $taskId');
    getAllData();
  }
}
