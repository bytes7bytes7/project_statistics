import 'dart:io';
import 'package:path/path.dart';
import 'package:project_statistics/global/global_parameters.dart';
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
        ${ConstDBData.startMonth} TEXT,
        ${ConstDBData.startYear} TEXT,
        ${ConstDBData.endMonth} TEXT,
        ${ConstDBData.endYear} TEXT,
        ${ConstDBData.prize} REAL,
        ${ConstDBData.percent} REAL,
        ${ConstDBData.ratio} REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstDBData.projectTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.title} TEXT,
        ${ConstDBData.status} TEXT,
        ${ConstDBData.price} INTEGER,
        ${ConstDBData.month} TEXT,
        ${ConstDBData.year} TEXT,
        ${ConstDBData.complete} TEXT
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
    plan.id = 1;
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.planTableName} (${ConstDBData.id}, ${ConstDBData.quantity}, ${ConstDBData.amount}, ${ConstDBData.startMonth}, ${ConstDBData.startYear},${ConstDBData.endMonth},${ConstDBData.endYear}, ${ConstDBData.prize}, ${ConstDBData.percent}, ${ConstDBData.ratio}) VALUES (?,?,?,?,?,?,?,?,?,?)",
      [
        plan.id,
        plan.quantity?.join(';'),
        plan.amount?.join(';'),
        plan.startMonth,
        plan.startYear,
        plan.endMonth,
        plan.endYear,
        plan.prize,
        plan.percent,
        plan.ratio,
      ],
    );
  }

  Future updatePlan(Plan plan) async {
    final db = await database;
    var map = plan.toMap();
    List<Map<String, dynamic>> data = await db.query(
        "${ConstDBData.planTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [1]);
    if (data.isNotEmpty) {
      await db.update("${ConstDBData.planTableName}", map,
          where: "${ConstDBData.id} = ?", whereArgs: [1]);
    } else {
      await addPlan(plan);
    }
  }

  Future<Plan> getPlan() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        "${ConstDBData.planTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [1]);
    if (data.isNotEmpty) {
      Map<String, dynamic> m = Map<String, dynamic>.from(data.first);
      List<String> a = [];
      m[ConstDBData.quantity] = (m[ConstDBData.quantity].length > 0)
          ? m[ConstDBData.quantity]
              .split(';')
              .map<int>((e) => int.parse(e))
              .toList()
          : a;
      m[ConstDBData.amount] = (m[ConstDBData.amount].length > 0)
          ? m[ConstDBData.amount]
              .split(';')
              .map<int>((e) => int.parse(e))
              .toList()
          : a;
      return Plan.fromMap(m);
    } else
      return Plan();
  }

  Future deletePlan() async {
    final db = await database;
    db.delete("${ConstDBData.planTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [1]);
  }

  // Project methods
  Future addProject(Project project) async {
    final db = await database;
    project.id = await _getMaxId(db, ConstDBData.projectTableName);
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.projectTableName} (${ConstDBData.id},${ConstDBData.title},${ConstDBData.status},${ConstDBData.price}, ${ConstDBData.month}, ${ConstDBData.year}, ${ConstDBData.complete}) VALUES (?,?,?,?,?,?,?)",
      [
        project.id,
        project.title,
        project.status,
        project.price,
        project.month,
        project.year,
        project.complete,
      ],
    );
  }

  Future addAllProjects(List<Project> projects) async {
    final db = await database;
    int id = await _getMaxId(db, ConstDBData.projectTableName);
    for (Project project in projects) {
      project.id = id;
      await db.rawInsert(
        "INSERT INTO ${ConstDBData.projectTableName} (${ConstDBData.id},${ConstDBData.title},${ConstDBData.status},${ConstDBData.price}, ${ConstDBData.month}, ${ConstDBData.year}, ${ConstDBData.complete}) VALUES (?,?,?,?,?,?,?)",
        [
          project.id,
          project.title,
          project.status,
          project.price,
          project.month,
          project.year,
          project.complete,
        ],
      );
      id++;
    }
  }

  Future updateProject(Project project) async {
    final db = await database;
    var map = project.toMap();
    await db.update("${ConstDBData.projectTableName}", map,
        where: "${ConstDBData.id} = ?", whereArgs: [project.id]);
  }

  Future<Project> getProject(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
        "${ConstDBData.projectTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
    return res.isNotEmpty ? Project.fromMap(res.first) : Project();
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query("${ConstDBData.projectTableName}");
    return res.isNotEmpty ? res.map((c) => Project.fromMap(c)).toList() : [];
  }

  Future deleteProject(int id) async {
    final db = await database;
    db.delete("${ConstDBData.projectTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [id]);
  }

  Future deleteAllProjects() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${ConstDBData.projectTableName}");
  }

  // Result methods
  Future<Result> getResult() async {
    final db = await database;
    Map<String, dynamic> result = Result().toMap();

    List<Map<String, dynamic>> projects =
        await db.query("${ConstDBData.projectTableName}");
    List<Map<String, dynamic>> plan = await db.query(
        "${ConstDBData.planTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [1]);

    // сумма договоров
    result['amount'] = 0.0;
    // кол-во договоров
    result['quantity'] = 0;
    // план
    result['plan'] = 0;
    // процент
    result['percent'] = 0;
    // сумма до
    result['until'] = 0.0;
    // премия
    result['prize'] = 0.0;

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        if (proj['status'] == ProjectStatuses.contract) {
          if (GlobalParameters.resultFilterBorders[0].isNotEmpty &&
              GlobalParameters.resultFilterBorders[1].isNotEmpty) {
            if (ConstantData.appMonths.indexOf(proj['startPeriod']) >=
                    ConstantData.appMonths
                        .indexOf(GlobalParameters.resultFilterBorders[0]) &&
                ConstantData.appMonths.indexOf(proj['endPeriod']) <=
                    ConstantData.appMonths
                        .indexOf(GlobalParameters.resultFilterBorders[1])) {
              result['amount'] += proj['price'];
              result['quantity']++;
            }
          } else if (GlobalParameters.resultFilterBorders[0].isNotEmpty) {
            if (ConstantData.appMonths.indexOf(proj['startPeriod']) >=
                ConstantData.appMonths
                    .indexOf(GlobalParameters.resultFilterBorders[0])) {
              result['amount'] += proj['price'];
              result['quantity']++;
            }
          } else if (GlobalParameters.resultFilterBorders[1].isNotEmpty) {
            if (ConstantData.appMonths.indexOf(proj['endPeriod']) <=
                ConstantData.appMonths
                    .indexOf(GlobalParameters.resultFilterBorders[1])) {
              result['amount'] += proj['price'];
              result['quantity']++;
            }
          } else {
            result['amount'] += proj['price'];
            result['quantity']++;
          }
        }
      });
    }

    if (plan.isNotEmpty) {
      result['plan'] += int.parse(plan.first['amount'].split(';')[3]);
      result['until'] = result['plan'] - result['amount'];
      if (result['until'] <= 0) {
        result['prize'] = plan.first['prize'];
      }
    }

    if (result['plan'] != 0) {
      result['percent'] = (100 * result['amount'] / result['plan']).round();
      result['plan']/=1000000;
    }

    return Result.fromMap(result);
  }

  // AnalysisChart methods
  Future<AnalysisChart> getAnalysisChart() async {
    final db = await database;
    Map<String, dynamic> result = AnalysisChart().toMap();

    List<Map<String, dynamic>> projects =
        await db.query("${ConstDBData.projectTableName}");
    List<Map<String, dynamic>> plan = await db.query(
        "${ConstDBData.planTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [1]);

    result['realQuantity'] =
        List<int>.generate(ProjectStatuses.length, (index) => 0);
    result['planQuantity'] =
        List<int>.generate(ProjectStatuses.length, (index) => 0);
    result['realAmount'] =
        List<double>.generate(ProjectStatuses.length, (index) => 0.0);
    result['planAmount'] =
        List<double>.generate(ProjectStatuses.length, (index) => 0.0);

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        int i = ProjectStatuses.indexOf(proj['status']);
        if (proj['complete'] != ProjectCompleteStatuses.canceled) {
          if (GlobalParameters.chartFilterBorders[0].isNotEmpty &&
              GlobalParameters.chartFilterBorders[1].isNotEmpty) {
            if (ConstantData.appMonths.indexOf(proj['startPeriod']) >=
                    ConstantData.appMonths
                        .indexOf(GlobalParameters.chartFilterBorders[0]) &&
                ConstantData.appMonths.indexOf(proj['endPeriod']) <=
                    ConstantData.appMonths
                        .indexOf(GlobalParameters.chartFilterBorders[1])) {
              result['realQuantity'][i]++;
              result['realAmount'][i] += proj['price'];
            }
          } else if (GlobalParameters.chartFilterBorders[0].isNotEmpty) {
            if (ConstantData.appMonths.indexOf(proj['startPeriod']) >=
                ConstantData.appMonths
                    .indexOf(GlobalParameters.chartFilterBorders[0])) {
              result['realQuantity'][i]++;
              result['realAmount'][i] += proj['price'];
            }
          } else if (ConstantData.appMonths.indexOf(proj['endPeriod']) <=
              ConstantData.appMonths
                  .indexOf(GlobalParameters.chartFilterBorders[1])) {
            result['realQuantity'][i]++;
            result['realAmount'][i] += proj['price'];
          } else {
            result['realQuantity'][i]++;
            result['realAmount'][i] += proj['price'];
          }
        }
      });
    }

    if (plan.isNotEmpty) {
      result['planAmount'] = plan.first['amount']
          .split(';')
          .map<double>((e) => double.parse(e))
          .toList();
      result['planQuantity'] = plan.first['quantity']
          .split(';')
          .map<int>((e) => int.parse(e))
          .toList();
    }

    return AnalysisChart.fromMap(result);
  }
}
