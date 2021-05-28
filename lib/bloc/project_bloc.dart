import 'dart:async';

import '../models/project.dart';
import '../repositories/project_repository.dart';

class ProjectBloc {
  ProjectBloc(this._repository);

  final ProjectRepository _repository;
  static StreamController _projectStreamController;

  Stream<ProjectState> get project {
    if (_projectStreamController == null || _projectStreamController.isClosed)
      _projectStreamController = StreamController<ProjectState>();
    return _projectStreamController.stream;
  }

  void dispose() {
    _projectStreamController.close();
  }

  void loadAllProjects() async {
    _projectStreamController.sink.add(ProjectState._projectLoading());
    _repository.getAllProjects().then((projectList) {
      projectList
          .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      if (!_projectStreamController.isClosed)
        _projectStreamController.sink.add(ProjectState._projectData(projectList));
    });
  }

  void deleteProject(int id) async{
    _projectStreamController.sink.add(ProjectState._projectLoading());
    _repository.deleteProject(id).then((value) {
      loadAllProjects();
    });
  }

  void updateProject(Project project) async{
    _projectStreamController.sink.add(ProjectState._projectLoading());
    _repository.updateProject(project).then((value) {
      loadAllProjects();
    });
  }

  Future addProject(Project project) async{
    _projectStreamController.sink.add(ProjectState._projectLoading());
    await _repository.addProject(project).then((value) {
      loadAllProjects();
    });
  }

}

class ProjectState {
  ProjectState();

  factory ProjectState._projectData(List<Project> projects) = ProjectDataState;

  factory ProjectState._projectLoading() = ProjectLoadingState;
}

class ProjectInitState extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectDataState extends ProjectState {
  ProjectDataState(this.projects);

  final List<Project> projects;
}
