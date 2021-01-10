import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/model/sample.dart';

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

  Future<List<Point>> getPoints() async {
    Database db = await this.getDatabase();
    List<Map> result = await db.rawQuery('SELECT * FROM $_tablePoints');
    return result.map<Point>((item) => Point.fromJson(item)).toList();
  }

  Future<Point> getPointById(String idPoint) async {
    Database db = await this.getDatabase();
    int id = int.parse(idPoint);
    List<Map> result =
        await db.rawQuery('SELECT * FROM $_tablePoints WHERE id = ?', [id]);
    print("RESULT" + result.toString());
    return Point.fromJson(result.first);
  }

  Future<List<Sample>> getSamplesById(String idPoint) async {
    Database db = await this.getDatabase();
    int id = int.parse(idPoint);
    List<Map> result = await db
        .rawQuery('SELECT * FROM $_tableSamples WHERE id_point = ?', [id]);
    return result.map<Sample>((item) => Sample.fromJson(item)).toList();
  }

  Future<String> getSamplesCountById(String idPoint) async {
    Database db = await this.getDatabase();
    int id = int.parse(idPoint);
    List<Map> result = await db.rawQuery(
        'SELECT COUNT (*) FROM $_tableSamples WHERE id_point = ?', [id]);
    int count = Sqflite.firstIntValue(result);
    return count.toString();
  }

  Future<String> addPoint(Point point) async {
    print(point.pointToJson().values);
    Database db = await this.getDatabase();
    var result = await db.insert(_tablePoints, point.pointToJson());
    return result.toString();
  }

  Future<String> addSample(Sample sample) async {
    print(sample.sampleToJson().values);
    Database db = await this.getDatabase();
    var result = await db.insert(_tableSamples, sample.sampleToJson());
    return result.toString();
  }

  Future<int> updatePoint(Point point) async {
    int id = int.parse(point.id);
    var db = await this.getDatabase();
    var result = await db.update(_tablePoints, point.pointToJson(),
        where: '$_colId = ?', whereArgs: [id]);

    print(result);
    return result;
  }

  Future<int> deletePoint(String idPoint) async {
    int id = int.parse(idPoint);
    var db = await this.getDatabase();

    await db.rawDelete('DELETE FROM $_tablePoints WHERE $_colId = $id');

    int result = await db
        .rawDelete('DELETE FROM $_tableSamples WHERE $_colIdPoint = $id');
    return result;
  }
}
