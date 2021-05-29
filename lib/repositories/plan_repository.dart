import 'package:project_statistics/database/database_helper.dart';

import '../models/plan.dart';

class PlanRepository {
  Future<Plan> getPlan() async {
    return await DatabaseHelper.db.getPlan();
    // return await Future.delayed(const Duration(seconds: 1)).then((value) {
    //   return Plan();
    //   // return Plan(
    //   //   quantity: [12, 35, 1, 5],
    //   //   amount: [10, 2, 4, 6],
    //   //   period: 'Май - Сентябрь',
    //   //   prize: 10,
    //   // );
    // });
  }

  Future deletePlan(int id) async {
    // await DatabaseHelper.db.deletePlan(id);
  }

  Future updatePlan(Plan plan) async {
    await DatabaseHelper.db.updatePlan(plan);
  }

  Future addPlan(Plan plan) async {
    // await DatabaseHelper.db.addPlan(plan);
  }
}
