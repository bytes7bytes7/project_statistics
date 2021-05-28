import '../database/database_helper.dart';
import '../models/project.dart';

class ProjectRepository {
  Future<List<Project>> getAllProjects() async {
    // return await DatabaseHelper.db.getAllProjects();
    return await Future.delayed(const Duration(seconds: 1)).then((value) {
      return [
        Project(
          id: 1,
          title: 'Проект 1',
          status: 'КП',
          price: 300000,
          startPeriod: 'Май',
          endPeriod: 'Май',
        ),
        Project(
          id: 2,
          title: 'Проект 2',
          status: 'Тендер',
          price: 100000,
          startPeriod: 'Май',
          endPeriod: 'Июнь',
        ),
        Project(
          id: 3,
          title: 'Проект 3',
          status: 'Договор',
          price: 500000,
          startPeriod: 'Май',
          endPeriod: 'Май',
        ),
        Project(
          id: 4,
          title: 'Проект 1',
          status: 'КП',
          price: 300000,
          startPeriod: 'Май',
          endPeriod: 'Май',
        ),
        Project(
          id: 5,
          title: 'Проект 2',
          status: 'Тендер',
          price: 100000,
          startPeriod: 'Май',
          endPeriod: 'Июнь',
        ),
        Project(
          id: 6,
          title: 'Проект 3',
          status: 'Договор',
          price: 500000,
          startPeriod: 'Май',
          endPeriod: 'Май',
        ),
      ];
    });
  }

  Future deleteProject(int id) async{
    // await DatabaseHelper.db.deleteProject(id);
  }

  Future updateProject(Project project)async{
    // await DatabaseHelper.db.updateProject(project);
  }

  Future addProject(Project project)async{
    // await DatabaseHelper.db.addProject(project);
  }
}
