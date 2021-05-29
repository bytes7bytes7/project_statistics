import 'plan_repository.dart';
import 'project_repository.dart';

abstract class Repository {
  static ProjectRepository projectRepository = ProjectRepository();
  static PlanRepository planRepository = PlanRepository();
}
