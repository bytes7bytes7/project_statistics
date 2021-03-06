import 'dart:async';

import '../models/project.dart';
import '../repositories/project_repository.dart';
import '../services/project_sort_filter_service.dart';

class ProjectBloc {
  ProjectBloc(this._repository);

  final ProjectRepository _repository;
  static StreamController _projectStreamController;

  Stream<ProjectState> get project {
    if (_projectStreamController == null || _projectStreamController.isClosed)
      _projectStreamController = StreamController<ProjectState>.broadcast();
    return _projectStreamController.stream;
  }

  void dispose() {
    _projectStreamController.close();
  }

  void loadAllProjects() async {
    _projectStreamController.sink.add(ProjectState._projectLoading());
    _repository.getAllProjects().then((projectList) {
      ProjectSortFilterService.filterProjectsBy(projectList);
      ProjectSortFilterService.sortProjectsBy(projectList);
      if(!_projectStreamController.isClosed)
        _projectStreamController.sink.add(ProjectState._projectData(projectList));
    }).onError((error, stackTrace) {
      if (!_projectStreamController.isClosed)
        _projectStreamController.sink.add(ProjectState._projectError(error,stackTrace));
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

  factory ProjectState._projectError(Error error, StackTrace stackTrace) = ProjectErrorState;
}

class ProjectInitState extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectErrorState extends ProjectState {
  ProjectErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ProjectDataState extends ProjectState {
  ProjectDataState(this.projects);

  final List<Project> projects;
}
