import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/todos.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper;
    } else {
      return _dataBaseHelper;
    }
  }

  DataBaseHelper._internal();

  getDataBase() async {
    if (_database == null) {
      debugPrint("db çagrılıyor");
      _database = await initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  initializeDatabase() async {
    debugPrint("db getiriliyor");
    Directory klasor = await getApplicationDocumentsDirectory();
    var dbpath = join(klasor.path, "todo").toString();
    var catchdb = await openDatabase(dbpath, version: 1, onCreate: _createdb);
    return catchdb;
  }

  FutureOr<void> _createdb(Database db, int version) async {
    debugPrint("db oluşturuluyor");
    var database = await db.execute(
        "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT,secim INTEGER,todo TEXT )");
    debugPrint("db oluşturuldu");
    return database;
  }

  Future<int> todoekle(Todos todo) async {
    Database db = await getDataBase();
    debugPrint("db eklendi");
    var value = await db.insert("todos", todo.tomap());
    debugPrint(value.toString());
    return value;
  }

  Future<int> todoupdate(Todos todo) async {
    Database db = await getDataBase();
    var value = await db
        .update("todos", todo.tomap(), where: "id=?", whereArgs: [todo.id]);
    debugPrint("db güncellendi");
    debugPrint("${value.toString()}");
    return value;
  }

  Future<int> todoDelete(int id) async {
    Database db = await getDataBase();
    var value = await db.delete("todos", where: "id=?", whereArgs: [id]);
    debugPrint("silindi");
    return value;
  }

  Future<List<Map<String, dynamic>>> alltodo() async {
    Database db = await getDataBase();
    var value = await db.query("todos");
    return value;
  }
}
