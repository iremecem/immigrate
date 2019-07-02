import 'dart:async';
import 'dart:io';

import 'package:immigrate/Models/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dummyNewest.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id TEXT, name TEXT, profilePic TEXT, fromi TEXT, toi TEXT)");
  }

  Future<int> saveEvent(User u) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", u.toJson());
    return res;
  }

  Future<List<User>> getEvents() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> user = new List();
    for (int i = 0; i < list.length; i++) {
      var event = new User(
        name: list[i]["name"],
        id: list[i]["id"],
        from: list[i]["from"],
        profilePic: list[i]["profilePic"],
        to: list[i]["to"],
      );
      user.add(event);
    }
    return user;
  }

  Future<int> deleteEvent(User u) async {
    var dbClient = await db;
    int res =
        await dbClient.delete('User', where: "id = ?", whereArgs: [u.id]);
    return res;
  }

  Future<bool> update(User u) async {
    var dbClient = await db;
    int res = await dbClient.update("User", u.toJson(),
        where: "id = ?", whereArgs: [u.id]);
    return res > 0 ? true : false;
  }
}
