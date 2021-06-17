import '../models/project.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

abstract class ProjectSortFilterService {
  static filterProjectsBy(List<Project> projects) {
    if (GlobalParameters.projectFilterBorders[0] == '' &&
        GlobalParameters.projectFilterBorders[1] == '') {
      return;
    }
    if (GlobalParameters.projectFilterBorders[0] != '' &&
        GlobalParameters.projectFilterBorders[1] != '') {
      for (int i = projects.length - 1; i >= 0; i--) {
        if (projects[i].date != GlobalParameters.projectFilterBorders[0] ||
            projects[i].status != GlobalParameters.projectFilterBorders[1]) {
          projects.removeAt(i);
        }
      }
    } else if (GlobalParameters.projectFilterBorders[0] != '') {
      for (int i = projects.length - 1; i >= 0; i--) {
        if (projects[i].date != GlobalParameters.projectFilterBorders[0]) {
          projects.removeAt(i);
        }
      }
    } else if (GlobalParameters.projectFilterBorders[1] != '') {
      for (int i = projects.length - 1; i >= 0; i--) {
        if (projects[i].status != GlobalParameters.projectFilterBorders[1]) {
          projects.removeAt(i);
        }
      }
    }
  }

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
            List<String> aList = a.date.split(' ');
            List<String> bList = b.date.split(' ');
            String aMonth = aList[0],
                aYear = aList[1],
                bMonth = bList[0],
                bYear = bList[1];

            String aDate = ConstantData.appMonths.indexOf(aMonth).toString();
            String bDate = ConstantData.appMonths.indexOf(bMonth).toString();
            if (aDate.length == 1) {
              aDate = '0' + aDate;
            }
            if (bDate.length == 1) {
              bDate = '0' + bDate;
            }
            aDate = aYear + aDate;
            bDate = bYear + bDate;
            return aDate.compareTo(bDate);
          });
        } else {
          projects.sort((a, b) {
            List<String> aList = a.date.split(' ');
            List<String> bList = b.date.split(' ');
            String aMonth = aList[0],
                aYear = aList[1],
                bMonth = bList[0],
                bYear = bList[1];

            String aDate = ConstantData.appMonths.indexOf(aMonth).toString();
            String bDate = ConstantData.appMonths.indexOf(bMonth).toString();
            if (aDate.length == 1) {
              aDate = '0' + aDate;
            }
            if (bDate.length == 1) {
              bDate = '0' + bDate;
            }
            aDate = aYear + aDate;
            bDate = bYear + bDate;
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
