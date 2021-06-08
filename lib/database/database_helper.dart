import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../models/analysis_chart.dart';
import '../models/plan.dart';
import '../models/project.dart';
import '../models/result.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // The pathConstDBData.provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, ConstDBData.databaseName);
    return await openDatabase(path,
        version: ConstDBData.databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstDBData.planTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.quantity} TEXT,
        ${ConstDBData.amount} TEXT,
        ${ConstDBData.startPeriod} TEXT,
        ${ConstDBData.endPeriod} TEXT,
        ${ConstDBData.prize} REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstDBData.projectTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.title} TEXT,
        ${ConstDBData.status} TEXT,
        ${ConstDBData.price} INTEGER,
        ${ConstDBData.startPeriod} TEXT,
        ${ConstDBData.endPeriod} TEXT
      )
    ''');
  }

  Future dropBD() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS ${ConstDBData.planTableName};');
    await db.execute('DROP TABLE IF EXISTS ${ConstDBData.projectTableName};');
    await _createDB(db, ConstDBData.databaseVersion);
  }

  Future<int> _getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery(
        "SELECT MAX(${ConstDBData.id})+1 AS ${ConstDBData.id} FROM $tableName");
    return table.first["${ConstDBData.id}"] ?? 1;
  }

  // Plan methods
  Future addPlan(Plan plan) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.planTableName} (${ConstDBData
          .quantity}, ${ConstDBData.amount}, ${ConstDBData
          .startPeriod}, ${ConstDBData.endPeriod}, ${ConstDBData
          .prize}) VALUES (?,?,?,?,?)",
      [
        plan.quantity?.join(';'),
        plan.amount?.join(';'),
        plan.startPeriod,
        plan.endPeriod,
        plan.prize,
      ],
    );
  }

  Future updatePlan(Plan plan) async {
    final db = await database;
    var map = plan.toMap();
    List<Map<String, dynamic>> data =
    await db.query(
        "${ConstDBData.planTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [1]);
    if (data.isNotEmpty) {
      await db
          .update(
          "${ConstDBData.planTableName}", map, where: "${ConstDBData.id} = ?",
          whereArgs: [1]);
    } else {
      await addPlan(plan);
    }
  }

  Future<Plan> getPlan() async {
    final db = await database;
    List<Map<String, dynamic>> data =
    await db.query(
        "${ConstDBData.planTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [1]);
    if (data.isNotEmpty) {
      Map<String, dynamic> m = Map<String, dynamic>.from(data.first);
      List<String> a = [];
      m[ConstDBData.quantity] = (m[ConstDBData.quantity].length > 0)
          ? m[ConstDBData.quantity].split(';')
          .map<int>((e) => int.parse(e))
          .toList()
          : a;
      m[ConstDBData.amount] = (m[ConstDBData.amount].length > 0)
          ? m[ConstDBData.amount].split(';')
          .map<double>((e) => double.parse(e))
          .toList()
          : a;
      return Plan.fromMap(m);
    } else
      return Plan();
  }

  Future deletePlan() async {
    final db = await database;
    db.delete("${ConstDBData.planTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [1]);
  }

  // Project methods
  Future addProject(Project project) async {
    final db = await database;
    project.id = await _getMaxId(db, ConstDBData.projectTableName);
    await db.rawInsert(
        "INSERT INTO ${ConstDBData.projectTableName} (${ConstDBData
            .id},${ConstDBData.title},${ConstDBData.status},${ConstDBData
            .price}, ${ConstDBData.startPeriod}, ${ConstDBData
            .endPeriod}) VALUES (?,?,?,?,?,?)",
        [
          project.id,
          project.title,
          project.status,
          project.price,
          project.startPeriod,
          project.endPeriod,
        ]);
  }

  Future updateProject(Project project) async {
    final db = await database;
    var map = project.toMap();
    await db.update("${ConstDBData.projectTableName}", map,
        where: "${ConstDBData.id} = ?", whereArgs: [project.id]);
  }

  Future<Project> getProject(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db
        .query(
        "${ConstDBData.projectTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
    return res.isNotEmpty ? Project.fromMap(res.first) : Project();
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
        "${ConstDBData.projectTableName}");
    return res.isNotEmpty ? res.map((c) => Project.fromMap(c)).toList() : [];
  }

  Future deleteProject(int id) async {
    final db = await database;
    db.delete("${ConstDBData.projectTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
  }

  Future deleteAllProjects() async {
    final db = await database;
    db.rawDelete("DELETE * FROM ${ConstDBData.projectTableName}");
  }

  // Result methods
  Future<Result> getResult(String startPeriod, String endPeriod) async {
    final db = await database;
    Map<String, dynamic> result = Result().toMap();

    List<Map<String, dynamic>> projects = await db.query(
        "${ConstDBData.projectTableName}");
    List<Map<String, dynamic>> plan =
    await db.query(
        "${ConstDBData.planTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [1]);

    // сумма договоров
    result['amount'] = 0.0;
    // кол-во договоров
    result['quantity'] = 0;
    // план
    result['plan'] = 0.0;
    // процент
    result['percent'] = 0;
    // сумма до
    result['until'] = 0.0;
    // премия
    result['prize'] = 0.0;

    // TODO: implement result['percent']

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        if (proj['status'] == ConstantData.appStatus[3]) {
          result['amount'] += proj['price'];
          result['quantity']++;
        }
        result['until'] -= proj['price'];
      });
    }

    if (plan.isNotEmpty) {
      plan.first['amount'].split(';').forEach((e) {
        result['plan'] += double.parse(e);
      });
      result['until'] += result['plan'] * 1000000;
      result['prize'] = plan.first['prize'];
    }

    return Result.fromMap(result);
  }

  // AnalysisChart methods
  Future<AnalysisChart> getAnalysisChart(String startPeriod,
      String endPeriod) async {
    final db = await database;
    Map<String, dynamic> result = AnalysisChart().toMap();

    List<Map<String, dynamic>> projects = await db.query(
        "${ConstDBData.projectTableName}");
    List<Map<String, dynamic>> plan =
    await db.query(
        "${ConstDBData.planTableName}", where: "${ConstDBData.id} = ?",
        whereArgs: [1]);

    result['realQuantity'] =
    List<int>.generate(ConstantData.appStatus.length, (index) => 0);
    result['planQuantity'] =
    List<int>.generate(ConstantData.appStatus.length, (index) => 0);
    result['realAmount'] =
    List<double>.generate(ConstantData.appStatus.length, (index) => 0.0);
    result['planAmount'] =
    List<double>.generate(ConstantData.appStatus.length, (index) => 0.0);

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        for (int i = 0; i < ConstantData.appStatus.length; i++) {
          if (proj['status'] == ConstantData.appStatus[i]) {
            result['realQuantity'][i]++;
            result['realAmount'][i] += proj['price'];
            break;
          }
        }
      });
    }

    if (plan.isNotEmpty) {
      result['planAmount'] = plan.first['amount'].split(';')
          .map<double>((e) => double.parse(e))
          .toList();
      result['planQuantity'] = plan.first['quantity'].split(';')
          .map<int>((e) => int.parse(e))
          .toList();
    }

    return AnalysisChart.fromMap(result);
  }
}