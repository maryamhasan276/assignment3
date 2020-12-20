import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/Models/Work.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; 
  static Database _database; 

  String workTable = 'work_table';
  String colId = 'Id';
  String colTitle = 'Title';
  String colKind = 'Kind';

  DatabaseHelper._createInstance(); 

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); 
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'work.db';

    
    var worksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return worksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $workTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colKind INTEGER DEFAULT 1)');
  }

 
  Future<List<Map<String, dynamic>>> getAllWorkMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $workTable ');
    return result;
  }

  
  Future<List<Map<String, dynamic>>> getCompleteWorkMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $workTable WHERE $colKind= 1');
    return result;
  }


  Future<List<Map<String, dynamic>>> getInCompleteWorkMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $workTable WHERE $colKind= 2');
    return result;
  }

  
  Future<int> insertwork(Work work) async {
    Database db = await this.database;
    var result = await db.insert(workTable, work.toMap());
    return result;
  }

  
  Future<int> updateworkInCompleted(Work work) async {
    var db = await this.database;
    var result = await db
        .update(workTable, work.toMap(), where: '$colKind = ?', whereArgs: [2]);
    return result;
  }

  Future<int> updateworkCompleted(Work work) async {
    var db = await this.database;
    var result = await db
        .update(workTable, work.toMap(), where: '$colKind = ?', whereArgs: [2]);
    return result;
  }

  
  Future<int> deletework(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $workTable WHERE $colId = $Id');
    return result;
  }

  
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $workTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  
  Future<List<Work>> getworkList(int kind) async {
    switch (kind) {
      case 1:
        {
          var workMapList = await getCompleteWorkMapList();
          int count =
              workMapList.length; 

          List<Work> workList = List<Work>();
     
          for (int i = 0; i < count; i++) {
            workList.add(Work.fromMapObject(workMapList[i]));
          }

          return workList; 
        }
        break;
      case 2:
        {
          var workMapList = await getInCompleteWorkMapList();
          int count =
              workMapList.length; 

          List<Work> workList = List<Work>();
         
          for (int i = 0; i < count; i++) {
            workList.add(Work.fromMapObject(workMapList[i]));
          }

          return workList;
        }
        break;
      default:
        {
          var workMapList = await getAllWorkMapList();
          int count =
              workMapList.length; 

          List<Work> workList = List<Work>();
         
          for (int i = 0; i < count; i++) {
            workList.add(Work.fromMapObject(workMapList[i]));
          }

          return workList;
        }
        break;
    }
  }
}
