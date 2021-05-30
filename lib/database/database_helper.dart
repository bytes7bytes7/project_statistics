import 'dart:io';
import 'package:path/path.dart';
import 'package:project_statistics/constants.dart';
import 'package:project_statistics/models/plan.dart';
import 'package:project_statistics/models/project.dart';
import 'package:project_statistics/models/result.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();
  static final _databaseName = "data.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Names of tables
  static const String _planTableName = 'plan';
  static const String _projectTableName = 'project';

  // Special columns for plan
  static const String _id = 'id';
  static const String _quantity = 'quantity';
  static const String _amount = 'amount';
  static const String _startPeriod = 'startPeriod';
  static const String _endPeriod = 'endPeriod';
  static const String _prize = 'prize';

  // Special columns for project
  static const String _title = 'title';
  static const String _status = 'status';
  static const String _price = 'price';

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_planTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_quantity TEXT,
        $_amount TEXT,
        $_startPeriod TEXT,
        $_endPeriod TEXT,
        $_prize REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_projectTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_title TEXT,
        $_status TEXT,
        $_price INTEGER,
        $_startPeriod TEXT,
        $_endPeriod TEXT
      )
    ''');
  }

  Future dropBD() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $_planTableName;');
    await db.execute('DROP TABLE IF EXISTS $_projectTableName;');
    await _createDB(db, _databaseVersion);
  }

  Future<int> _getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery("SELECT MAX($_id)+1 AS $_id FROM $tableName");
    return table.first["$_id"] ?? 1;
  }

  // Plan methods
  Future addPlan(Plan plan) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO $_planTableName ($_quantity, $_amount, $_startPeriod, $_endPeriod, $_prize) VALUES (?,?,?,?,?)",
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
        await db.query("$_planTableName", where: "$_id = ?", whereArgs: [1]);
    if (data.isNotEmpty) {
      await db
          .update("$_planTableName", map, where: "$_id = ?", whereArgs: [1]);
    } else {
      await addPlan(plan);
    }
  }

  Future<Plan> getPlan() async {
    final db = await database;
    List<Map<String, dynamic>> data =
        await db.query("$_planTableName", where: "$_id = ?", whereArgs: [1]);
    if (data.isNotEmpty) {
      Map<String, dynamic> m = Map<String, dynamic>.from(data.first);
      List<String> a = [];
      m[_quantity] = (m[_quantity].length > 0)
          ? m[_quantity].split(';').map<int>((e) => int.parse(e)).toList()
          : a;
      m[_amount] = (m[_amount].length > 0)
          ? m[_amount].split(';').map<int>((e) => int.parse(e)).toList()
          : a;
      return Plan.fromMap(m);
    } else
      return Plan();
  }

  Future deletePlan() async {
    final db = await database;
    db.delete("$_planTableName", where: "$_id = ?", whereArgs: [1]);
  }

  // Project methods
  Future addProject(Project project) async {
    final db = await database;
    project.id = await _getMaxId(db, _projectTableName);
    await db.rawInsert(
        "INSERT INTO $_projectTableName ($_id,$_title,$_status,$_price, $_startPeriod, $_endPeriod) VALUES (?,?,?,?,?,?)",
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
    await db.update("$_projectTableName", map,
        where: "$_id = ?", whereArgs: [project.id]);
  }

  Future<Project> getProject(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db
        .query("$_projectTableName", where: "$_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Project.fromMap(res.first) : Project();
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("$_projectTableName");
    return res.isNotEmpty ? res.map((c) => Project.fromMap(c)).toList() : [];
  }

  Future deleteProject(int id) async {
    final db = await database;
    db.delete("$_projectTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllProjects() async {
    final db = await database;
    db.rawDelete("DELETE * FROM $_projectTableName");
  }

  // Result methods
  Future<Result> getResult(String startPeriod, String endPeriod) async {
    final db = await database;
    Map<String, dynamic> result = Result().toMap();

    List<Map<String, dynamic>> projects = await db.query("$_projectTableName");
    List<Map<String, dynamic>> plan =
        await db.query("$_planTableName", where: "$_id = ?", whereArgs: [1]);

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

    if (projects.isNotEmpty) {
      projects.forEach((proj) {
        if (proj['status'] == ConstantData.appStatus[3]) {
          result['amount'] += proj['price'];
          result['quantity']++;
        }
      });
    }

    if (plan.isNotEmpty) {
      plan.first['amount'].split(';').forEach((e) {
        result['plan'] += int.parse(e);
      });
      result['prize'] = plan.first['prize'];
    }

    return Result.fromMap(result);
  }

// // Order methods
// Future addOrder(Order order) async {
//   final db = await database;
//   order.id = await _getMaxId(db, _orderTableName);
//   await db.rawInsert(
//     "INSERT INTO $_orderTableName ($_id, $_client, $_price, $_fabrics, $_expenses, $_date, $_done, $_comment) VALUES (?,?,?,?,?,?,?,?)",
//     [
//       order.id,
//       order.client.id,
//       order.price,
//       order.fabrics.map((e) => e.id).join(';'),
//       order.expenses,
//       order.date,
//       order.done,
//       order.comment,
//     ],
//   );
// }
//
// Future updateOrder(Order order) async {
//   final db = await database;
//   var map = order.toMap();
//   map[_client] = map[_client].id;
//   map[_fabrics] = map[_fabrics].map((e) => e.id)?.join(';');
//   await db.update("$_orderTableName", map,
//       where: "$_id = ?", whereArgs: [order.id]);
// }
//
// Future<Order> getOrder(int id) async {
//   final db = await database;
//   List<Map<String, dynamic>> res =
//   await db.query("$_orderTableName", where: "$_id = ?", whereArgs: [id]);
//   res.first[_client] = getClient(res.first[_client]);
//   res.first[_fabrics] = List<int>.from(res.first[_fabrics]?.split(';'))
//       .map((id) => getFabric(id));
//   return res.isNotEmpty ? Order.fromMap(res.first) : null;
// }
//
// Future<List<Order>> getAllOrders() async {
//   final db = await database;
//   List<Map<String, dynamic>> data = await db.query("$_orderTableName");
//   List<Map<String, dynamic>> result = [];
//   if (data.isNotEmpty) {
//     for (int i = 0; i < data.length; i++) {
//       Map<String, dynamic> m = Map<String, dynamic>.from(data[i]);
//       m[_client] = await getClient(m[_client]);
//       if (m[_client].id == null) {
//         await deleteOrder(m[_id]);
//         continue;
//       }
//       if (m[_fabrics].length > 0) {
//         List<String> ids = m[_fabrics].split(';');
//         m[_fabrics] = List<Fabric>.from([]).toList();
//         for (int j = 0; j < ids.length; j++) {
//           Fabric f = await getFabric(int.parse(ids[j]));
//           if (f.id == null) {
//             await deleteFabric(int.parse(ids[j]));
//           } else {
//             await m[_fabrics].add(f);
//           }
//         }
//       } else
//         m[_fabrics] = List<Fabric>.from([]).toList();
//
//       result.add(m);
//     }
//     return result.map<Order>((e) => Order.fromMap(e)).toList();
//   } else
//     return [];
// }
//
// Future deleteOrder(int id) async {
//   final db = await database;
//   db.delete("$_orderTableName", where: "$_id = ?", whereArgs: [id]);
// }
//
// Future deleteAllOrders() async {
//   final db = await database;
//   db.rawDelete("DELETE * FROM $_orderTableName");
// }
//
// // Settings methods
// Future addSettings(Settings settings) async {
//   final db = await database;
//   await db.rawInsert(
//     "INSERT INTO $_settingsTableName ($_id, $_appTitle, $_icon) VALUES (?,?,?)",
//     [
//       1,
//       settings.appTitle,
//       settings.icon,
//     ],
//   );
// }
//
// Future updateSettings(Settings settings) async {
//   final db = await database;
//   var map = settings.toMap();
//   try {
//     await db.update("$_settingsTableName", map,
//         where: "$_id = ?", whereArgs: [settings.id]);
//   } catch (error) {
//     await addSettings(Settings(
//       id: 1,
//       appTitle: map['appTitle'],
//       icon: map['icon'],
//     ));
//   }
// }
//
// Future<Settings> getSettings() async {
//   final db = await database;
//   List<Map<String, dynamic>> res;
//   try {
//     res = await db.query("$_settingsTableName");
//     if (res.length == 0) {
//       await addSettings(Settings(
//         id: 1,
//         appTitle: ConstData.appTitle,
//         icon: null,
//       ));
//       res = await db.query("$_settingsTableName");
//     }
//   } catch (error) {
//     await _createDB(db, _databaseVersion);
//     addSettings(Settings(
//       id: 1,
//       appTitle: ConstData.appTitle,
//       icon: null,
//     ));
//     res = await db.query("$_settingsTableName");
//   }
//   return res.isNotEmpty
//       ? Settings.fromMap(res.first)
//       : Settings(appTitle: null, icon: null);
// }
}
