import 'project_bloc.dart';
import '../repositories/repository.dart';

class Bloc {
  Bloc._privateConstructor();

  static final Bloc bloc = Bloc._privateConstructor();

  static ProjectBloc _projectBloc;

  ProjectBloc get projectBloc {
    if (_projectBloc != null) return _projectBloc;
    _projectBloc = ProjectBloc(Repository.projectRepository);
    return _projectBloc;
  }
}
