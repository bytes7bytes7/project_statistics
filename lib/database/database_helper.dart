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
      CREATE TABLE IF NOT EXISTS ${ConstDBData.planTableName.en} (
        ${ConstDBData.id.en} INTEGER PRIMARY KEY,
        ${ConstDBData.quantity.en} TEXT,
        ${ConstDBData.amount.en} TEXT,
        ${ConstDBData.startMonth.en} TEXT,
        ${ConstDBData.startYear.en} INTEGER,
        ${ConstDBData.endMonth.en} TEXT,
        ${ConstDBData.endYear.en} INTEGER,
        ${ConstDBData.prize.en} REAL,
        ${ConstDBData.percent.en} REAL,
        ${ConstDBData.ratio.en} REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstDBData.projectTableName.en} (
        ${ConstDBData.id.en} INTEGER PRIMARY KEY,
        ${ConstDBData.title.en} TEXT,
        ${ConstDBData.status.en} TEXT,
        ${ConstDBData.price.en} INTEGER,
        ${ConstDBData.month.en} TEXT,
        ${ConstDBData.year.en} INTEGER,
        ${ConstDBData.complete.en} TEXT
      )
    ''');
  }

  Future dropBD() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS ${ConstDBData.planTableName.en};');
    await db.execute('DROP TABLE IF EXISTS ${ConstDBData.projectTableName.en};');
    await _createDB(db, ConstDBData.databaseVersion);
  }

  Future<int> _getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery(
        "SELECT MAX(${ConstDBData.id.en})+1 AS ${ConstDBData.id.en} FROM $tableName");
    return table.first["${ConstDBData.id.en}"] ?? 1;
  }

  // Plan methods
  Future addPlan(Plan plan) async {
    final db = await database;
    plan.id = 1;
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.planTableName.en} (${ConstDBData.id.en}, ${ConstDBData.quantity.en}, ${ConstDBData.amount.en}, ${ConstDBData.startMonth.en}, ${ConstDBData.startYear.en}, ${ConstDBData.endMonth.en}, ${ConstDBData.endYear.en}, ${ConstDBData.prize.en}, ${ConstDBData.percent.en}, ${ConstDBData.ratio.en}) VALUES (?,?,?,?,?,?,?,?,?,?)",
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
        "${ConstDBData.planTableName.en}",
        where: "${ConstDBData.id.en} = ?",
        whereArgs: [1]);
    if (data.isNotEmpty) {
      await db.update("${ConstDBData.planTableName.en}", map,
          where: "${ConstDBData.id.en} = ?", whereArgs: [1]);
    } else {
      await addPlan(plan);
    }
  }

  Future<Plan> getPlan() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> data = await db.query(
          "${ConstDBData.planTableName.en}",
          where: "${ConstDBData.id.en} = ?",
          whereArgs: [1]);
      if (data.isNotEmpty) {
        Map<String, dynamic> map = Plan.formatMap(data.first);
        if (map != null && map.length > 0) {
          return Plan.fromMap(map);
        }
        return Plan();
      } else
        return Plan();
    } catch (error) {
      throw error;
    }
  }

  Future deletePlan() async {
    final db = await database;
    db.delete("${ConstDBData.planTableName.en}",
        where: "${ConstDBData.id.en} = ?", whereArgs: [1]);
  }

  // Project methods
  Future addProject(Project project) async {
    final db = await database;
    project.id = await _getMaxId(db, ConstDBData.projectTableName.en);
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.projectTableName.en} (${ConstDBData.id.en},${ConstDBData.title.en},${ConstDBData.status.en},${ConstDBData.price.en}, ${ConstDBData.month.en}, ${ConstDBData.year.en}, ${ConstDBData.complete.en}) VALUES (?,?,?,?,?,?,?)",
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
    int id = await _getMaxId(db, ConstDBData.projectTableName.en);
    for (Project project in projects) {
      project.id = id;
      await db.rawInsert(
        "INSERT INTO ${ConstDBData.projectTableName.en} (${ConstDBData.id.en},${ConstDBData.title.en},${ConstDBData.status.en},${ConstDBData.price.en}, ${ConstDBData.month.en}, ${ConstDBData.year.en}, ${ConstDBData.complete.en}) VALUES (?,?,?,?,?,?,?)",
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
    await db.update("${ConstDBData.projectTableName.en}", map,
        where: "${ConstDBData.id.en} = ?", whereArgs: [project.id]);
  }

  Future<Project> getProject(int id) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> res = await db.query(
          "${ConstDBData.projectTableName.en}",
          where: "${ConstDBData.id.en} = ?",
          whereArgs: [id]);
      return res.isNotEmpty ? Project.fromMap(res.first) : Project();
    } catch (error) {
      throw error;
    }
  }

  Future<List<Project>> getAllProjects() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> res =
          await db.query("${ConstDBData.projectTableName.en}");
      return res.isNotEmpty ? res.map((c) => Project.fromMap(c)).toList() : [];
    } catch (error) {
      throw error;
    }
  }

  Future deleteProject(int id) async {
    final db = await database;
    db.delete("${ConstDBData.projectTableName.en}",
        where: "${ConstDBData.id.en} = ?", whereArgs: [id]);
  }

  Future deleteAllProjects() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${ConstDBData.projectTableName.en}");
  }

  // Result methods
  Future<Result> getResult() async {
    final db = await database;
    Map<String, dynamic> result = Result().toMap();

    List<Map<String, dynamic>> projects =
        await db.query("${ConstDBData.projectTableName.en}");
    List<Map<String, dynamic>> plan = await db.query(
        "${ConstDBData.planTableName.en}",
        where: "${ConstDBData.id.en} = ?",
        whereArgs: [1]);

    // сумма договоров
    result['amount'] = 0.0;
    // кол-во договоров
    result['quantity'] = 0;
    // план
    result['plan'] = 0;
    // процент
    // Need to be double because of prize
    result['percent'] = 0.0;
    // сумма до
    result['until'] = 0.0;
    // премия
    result['prize'] = 0.0;

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        if (proj['status'] == ProjectStatuses.contract &&
            proj['complete'] != ProjectCompleteStatuses.canceled) {
          if (GlobalParameters.chartFilterBorders[0].isNotEmpty &&
              GlobalParameters.chartFilterBorders[1].isNotEmpty &&
              GlobalParameters.chartFilterBorders[2].isNotEmpty &&
              GlobalParameters.chartFilterBorders[3].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String startMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[0])
                .toString();
            String startYear = GlobalParameters.chartFilterBorders[1];
            if (startMonth.length < 2) {
              startMonth = '0' + startMonth;
            }
            int startDate = int.parse(startYear + startMonth);

            String endMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[2])
                .toString();
            String endYear = GlobalParameters.chartFilterBorders[3];
            if (endMonth.length < 2) {
              endMonth = '0' + endMonth;
            }
            int endDate = int.parse(endYear + endMonth);

            if (thisDate >= startDate && thisDate <= endDate) {
              result['amount'] += proj['price'];
              result['quantity']++;
            }
          } else if (GlobalParameters.chartFilterBorders[0].isNotEmpty &&
              GlobalParameters.chartFilterBorders[1].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String startMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[0])
                .toString();
            String startYear = GlobalParameters.chartFilterBorders[1];
            if (startMonth.length < 2) {
              startMonth = '0' + startMonth;
            }
            int startDate = int.parse(startYear + startMonth);

            if (thisDate >= startDate) {
              result['amount'] += proj['price'];
              result['quantity']++;
            }
          } else if (GlobalParameters.chartFilterBorders[2].isNotEmpty &&
              GlobalParameters.chartFilterBorders[3].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String endMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[2])
                .toString();
            String endYear = GlobalParameters.chartFilterBorders[3];
            if (endMonth.length < 2) {
              endMonth = '0' + endMonth;
            }
            int endDate = int.parse(endYear + endMonth);

            if (thisDate <= endDate) {
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
      result['plan'] += double.parse(plan.first['amount'].split(';')[3]);
      result['until'] = result['plan'] - result['amount'];
      if (result['until'] < 0) {
        result['until'] = 0.0;
      }

      if (result['plan'] != 0) {
        result['percent'] = 100 * result['amount'] / result['plan'];
      }

      if (result['percent'] > 100.0) {
        result['prize'] = plan.first['prize'] * plan.first['ratio'];
      } else if (result['percent'] >= plan.first['percent']) {
        result['prize'] = plan.first['prize'];
      }
    }

    result['percent'] = result['percent'].round();

    return Result.fromMap(result);
  }

  // AnalysisChart methods
  Future<AnalysisChart> getAnalysisChart() async {
    final db = await database;
    Map<String, dynamic> result = AnalysisChart().toMap();

    List<Map<String, dynamic>> projects =
        await db.query("${ConstDBData.projectTableName.en}");
    List<Map<String, dynamic>> plan = await db.query(
        "${ConstDBData.planTableName.en}",
        where: "${ConstDBData.id.en} = ?",
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
              GlobalParameters.chartFilterBorders[1].isNotEmpty &&
              GlobalParameters.chartFilterBorders[2].isNotEmpty &&
              GlobalParameters.chartFilterBorders[3].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String startMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[0])
                .toString();
            String startYear = GlobalParameters.chartFilterBorders[1];
            if (startMonth.length < 2) {
              startMonth = '0' + startMonth;
            }
            int startDate = int.parse(startYear + startMonth);

            String endMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[2])
                .toString();
            String endYear = GlobalParameters.chartFilterBorders[3];
            if (endMonth.length < 2) {
              endMonth = '0' + endMonth;
            }
            int endDate = int.parse(endYear + endMonth);

            if (thisDate >= startDate && thisDate <= endDate) {
              result['realQuantity'][i]++;
              result['realAmount'][i] += proj['price'];
            }
          } else if (GlobalParameters.chartFilterBorders[0].isNotEmpty &&
              GlobalParameters.chartFilterBorders[1].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String startMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[0])
                .toString();
            String startYear = GlobalParameters.chartFilterBorders[1];
            if (startMonth.length < 2) {
              startMonth = '0' + startMonth;
            }
            int startDate = int.parse(startYear + startMonth);

            if (thisDate >= startDate) {
              result['realQuantity'][i]++;
              result['realAmount'][i] += proj['price'];
            }
          } else if (GlobalParameters.chartFilterBorders[2].isNotEmpty &&
              GlobalParameters.chartFilterBorders[3].isNotEmpty) {
            String thisMonth =
                ConstantData.appMonths.indexOf(proj['month']).toString();
            String thisYear = proj['year'].toString();
            if (thisMonth.length < 2) {
              thisMonth = '0' + thisMonth;
            }
            int thisDate = int.parse(thisYear + thisMonth);

            String endMonth = ConstantData.appMonths
                .indexOf(GlobalParameters.chartFilterBorders[2])
                .toString();
            String endYear = GlobalParameters.chartFilterBorders[3];
            if (endMonth.length < 2) {
              endMonth = '0' + endMonth;
            }
            int endDate = int.parse(endYear + endMonth);

            if (thisDate <= endDate) {
              result['realQuantity'][i]++;
              result['realAmount'][i] += proj['price'];
            }
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
          .map<double>((e) => double.parse(e) / 1000000)
          .toList();
      result['planQuantity'] = plan.first['quantity']
          .split(';')
          .map<int>((e) => int.parse(e))
          .toList();
    }

    return AnalysisChart.fromMap(result);
  }
}
