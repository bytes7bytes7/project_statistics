import '../models/project.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

abstract class ProjectSortService {
  static sortProjectsBy(List<Project> projects) {
    switch (
        ProjectParameterNames.indexOf(GlobalParameters.projectSortParamName)) {
      case 0:
        if (ConstantData.appProjectParameterDirection
                .indexOf(GlobalParameters.projectSortParamDirection) ==
            0) {
          projects.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        } else {
          projects.sort(
              (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        }
        break;
      case 1:
        if (ConstantData.appProjectParameterDirection
                .indexOf(GlobalParameters.projectSortParamDirection) ==
            0) {
          projects.sort((a, b) => a.price.compareTo(b.price));
        } else {
          projects.sort((a, b) => b.price.compareTo(a.price));
        }
        break;
      case 2:
        if (ConstantData.appProjectParameterDirection
                .indexOf(GlobalParameters.projectSortParamDirection) ==
            0) {
          projects.sort((a, b) =>
              a.status.toLowerCase().compareTo(b.status.toLowerCase()));
        } else {
          projects.sort((a, b) =>
              b.status.toLowerCase().compareTo(a.status.toLowerCase()));
        }
        break;
      case 3:
        if (ConstantData.appProjectParameterDirection
                .indexOf(GlobalParameters.projectSortParamDirection) ==
            0) {
          projects.sort((a, b) {
            String aDate = ConstantData.appMonths.indexOf(a.month).toString();
            String bDate = ConstantData.appMonths.indexOf(b.month).toString();
            if (aDate.length == 1) {
              aDate = '0' + aDate;
            }
            if (bDate.length == 1) {
              bDate = '0' + bDate;
            }
            aDate = a.year.toString() + aDate;
            bDate = b.year.toString() + bDate;
            return aDate.compareTo(bDate);
          });
        } else {
          projects.sort((a, b) {
            String aDate = ConstantData.appMonths.indexOf(a.month).toString();
            String bDate = ConstantData.appMonths.indexOf(b.month).toString();
            if (aDate.length == 1) {
              aDate = '0' + aDate;
            }
            if (bDate.length == 1) {
              bDate = '0' + bDate;
            }
            aDate = a.year.toString() + aDate;
            bDate = b.year.toString() + bDate;
            return bDate.compareTo(aDate);
          });
        }
        break;
      case 4:
        if (ConstantData.appProjectParameterDirection
                .indexOf(GlobalParameters.projectSortParamDirection) ==
            0) {
          projects.sort((a, b) =>
              a.complete.toLowerCase().compareTo(b.complete.toLowerCase()));
        } else {
          projects.sort((a, b) =>
              b.complete.toLowerCase().compareTo(a.complete.toLowerCase()));
        }
        break;
      default:
        throw Exception(
            'Implement it!!! Because this type of sort is not implemented yet!');
    }
  }
}
