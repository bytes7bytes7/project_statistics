import 'package:project_statistics/constants.dart';
import 'package:project_statistics/models/project.dart';
import 'package:project_statistics/screens/global/global_parameters.dart';

abstract class ProjectSortService {
  static sortProjectsBy(List<Project> projects) {
    switch (ConstantData.appProjectParameterNames
        .indexOf(GlobalParameters.projectSortParamName)) {
      case 0:
        if(ConstantData.appProjectParameterDirection.indexOf(GlobalParameters.projectSortParamDirection) == 0){
          projects
              .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        }else{
          projects
              .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        }
        break;
      case 1:
        if(ConstantData.appProjectParameterDirection.indexOf(GlobalParameters.projectSortParamDirection) == 0){
          projects
              .sort((a, b) => a.price.compareTo(b.price));
        }else{
          projects
              .sort((a, b) => b.price.compareTo(a.price));
        }
        break;
      case 2:
        if(ConstantData.appProjectParameterDirection.indexOf(GlobalParameters.projectSortParamDirection) == 0){
          projects
              .sort((a, b) => a.status.toLowerCase().compareTo(b.status.toLowerCase()));
        }else{
          projects
              .sort((a, b) => b.status.toLowerCase().compareTo(a.status.toLowerCase()));
        }
        break;
      case 3:
        if(ConstantData.appProjectParameterDirection.indexOf(GlobalParameters.projectSortParamDirection) == 0){
          projects
              .sort((a, b) => ConstantData.appMonths.indexOf(a.startPeriod).compareTo(ConstantData.appMonths.indexOf(b.startPeriod)));
        }else{
          projects
              .sort((a, b) => ConstantData.appMonths.indexOf(b.startPeriod).compareTo(ConstantData.appMonths.indexOf(a.startPeriod)));
        }
        break;
      default:
        throw Exception('Implement it!!! Because this type of sort is not implemented yet!');
    }

  }
}
