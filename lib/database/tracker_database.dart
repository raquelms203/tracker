import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker/model/point.dart';

class TrackerDatabase {
  static TrackerDatabase _databaseHelper;

  static Database _database;

  String _colId = 'id';
  String _colCreated = 'created_at';
  String _colUpdated = 'updated_at';

  String _tablePoints = 'points';
  String _colCode = 'code';
  String _colX = 'x';
  String _colY = 'y';

  String _tableSamples = "samples";
  String _colIdPoint = 'id_point';
  String _colDate = 'date';
  String _colParameter = 'parameter';
  String _colValue = 'value';

  TrackerDatabase._createInstance();

  factory TrackerDatabase() {
    if (_databaseHelper == null) {
      _databaseHelper = TrackerDatabase._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      _database = await iniciarDb();
    }
    return _database;
  }

  Future<Database> iniciarDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'database9.db';
    Database database =
        await openDatabase(path, version: 1, onCreate: _criarDb);
    return database;
  }

  void _criarDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $_tablePoints(
        $_colId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
        $_colCreated INTEGER NOT NULL,
        $_colUpdated INTEGER NOT NULL,
        $_colCode TEXT NOT NULL,
        $_colX REAL NOT NULL,
        $_colY REAL NOT NULL)
    ''');

    await db.execute('''
      CREATE TABLE $_tableSamples(
        $_colId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
        $_colIdPoint INTEGER NOT NULL,
        $_colDate INTEGER NOT NULL,
        $_colCreated INTEGER NOT NULL,
        $_colUpdated INTEGER NOT NULL,
        $_colParameter TEXT NOT NULL,
        $_colValue REAL NOT NULL)
    ''');
  }

  Future<List<Map<String, dynamic>>> getPoints() async {
    Database db = await this.getDatabase();
    List<Map> result = await db.rawQuery('SELECT * FROM $_tablePoints');
    return result;
  }

  Future<int> addPoint(Point point) async {
    print(point.pointToJson().values);
    Database db = await this.getDatabase();
    var result = await db.insert(_tablePoints, point.pointToJson());
    print(result);
    return result;
  }
// Future<int> atualizarDisciplina(Disciplina disciplina, {String nomeAntigo}) async {
//     var db = await this.getDatabase();
//     var result = await db.update(tableDisciplinas, disciplina.disciplinaToMap(),
//         where: '$colIdDisciplina = ?', whereArgs: [disciplina.getId()]);

//     if(nomeAntigo != null) {
//          await db.rawUpdate("UPDATE $tableTarefas SET $colDisciplina = '${disciplina.getDisciplina()}' WHERE $colDisciplina = '$nomeAntigo'");

//     }
//     return result;
//   }
//  Future<int> apagarDisciplina(int id) async {
//     var db = await this.getDatabase();
//     int result = await db.rawDelete(
//         'DELETE FROM $tableDisciplinas WHERE $colIdDisciplina = $id');
//     return result;
//   }

}
