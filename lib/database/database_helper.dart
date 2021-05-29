import 'dart:io';
import 'package:path/path.dart';
import 'package:project_statistics/models/plan.dart';
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

  // Special columns for plan
  static const String _id = 'id';
  static const String _quantity = 'quantity';
  static const String _amount = 'amount';
  static const String _period = 'period';
  static const String _prize = 'prize';

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
        $_period TEXT,
        $_prize REAL
      )
    ''');
  }

  Future dropBD() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $_planTableName;');
    await _createDB(db, _databaseVersion);
  }

  // Future<int> _getMaxId(Database db, String tableName) async {
  //   var table = await db.rawQuery("SELECT MAX($_id)+1 AS $_id FROM $tableName");
  //   return table.first["$_id"] ?? 1;
  // }

  // Plan methods
  Future addPlan(Plan plan) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO $_planTableName ($_quantity, $_amount, $_period, $_prize) VALUES (?,?,?,?)",
      [
        plan.quantity?.join(';'),
        plan.amount?.join(';'),
        plan.period,
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
      m[_quantity] = (m[_quantity].length > 0) ? m[_quantity].split(';').map<int>((e) => int.parse(e)).toList() : a;
      m[_amount] = (m[_amount].length > 0) ? m[_amount].split(';').map<double>((e) => double.parse(e)).toList() : a;
      return Plan.fromMap(m);
    } else
      return Plan();
  }

// Future deleteClient(int id) async {
//   final db = await database;
//   db.delete("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
// }

// // Fabric methods
// Future addFabric(Fabric fabric) async {
//   final db = await database;
//   fabric.id = await _getMaxId(db, _fabricTableName);
//   await db.rawInsert(
//       "INSERT INTO $_fabricTableName ($_id,$_title,$_retailPrice,$_purchasePrice) VALUES (?,?,?,?)",
//       [
//         fabric.id,
//         fabric.title,
//         fabric.retailPrice,
//         fabric.purchasePrice,
//       ]);
// }
//
// Future updateFabric(Fabric fabric) async {
//   final db = await database;
//   var map = fabric.toMap();
//   await db.update("$_fabricTableName", map,
//       where: "$_id = ?", whereArgs: [fabric.id]);
// }
//
// Future<Fabric> getFabric(int id) async {
//   final db = await database;
//   List<Map<String, dynamic>> res =
//   await db.query("$_fabricTableName", where: "$_id = ?", whereArgs: [id]);
//   return res.isNotEmpty ? Fabric.fromMap(res.first) : Fabric();
// }
//
// Future<List<Fabric>> getAllFabrics() async {
//   final db = await database;
//   List<Map<String, dynamic>> res = await db.query("$_fabricTableName");
//   return res.isNotEmpty ? res.map((c) => Fabric.fromMap(c)).toList() : [];
// }
//
// Future deleteFabric(int id) async {
//   final db = await database;
//   db.delete("$_fabricTableName", where: "$_id = ?", whereArgs: [id]);
// }
//
// Future deleteAllFabrics() async {
//   final db = await database;
//   db.rawDelete("DELETE * FROM $_fabricTableName");
// }
//
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
