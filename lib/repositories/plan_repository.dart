import '../database/database_helper.dart';
import '../models/plan.dart';

class PlanRepository {
  Future<Plan> getPlan() async {
    return await DatabaseHelper.db.getPlan();
  }

  Future deletePlan(int id) async {
    await DatabaseHelper.db.deletePlan();
  }

  Future updatePlan(Plan plan) async {
    await DatabaseHelper.db.updatePlan(plan);
  }
}
