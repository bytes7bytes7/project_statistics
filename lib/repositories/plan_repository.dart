import '../models/plan.dart';
import '../models/project.dart';
import '../database/database_helper.dart';

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

  Future importExcel(List<Project> projects) async {
    try {
      await DatabaseHelper.db.deleteAllProjects();
      await DatabaseHelper.db.addAllProjects(projects);
    } catch (error) {
      throw error;
    }
  }
}
