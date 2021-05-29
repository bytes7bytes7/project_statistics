import 'package:project_statistics/database/database_helper.dart';

import '../models/project.dart';

class ProjectRepository {
  Future<List<Project>> getAllProjects() async {
    return await DatabaseHelper.db.getAllProjects();
  }

  Future deleteProject(int id) async{
    await DatabaseHelper.db.deleteProject(id);
  }

  Future updateProject(Project project)async{
    await DatabaseHelper.db.updateProject(project);
  }

  Future addProject(Project project)async{
    await DatabaseHelper.db.addProject(project);
  }
}
