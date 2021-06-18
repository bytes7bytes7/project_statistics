import '../models/project.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

abstract class ProjectSortFilterService {
  static filterProjectsBy(List<Project> projects) {
    int filterMonth, filterYear;
    String filterStatus;
    if (GlobalParameters.projectFilterBorders[0].isNotEmpty) {
      filterMonth = ConstantData.appMonths
          .indexOf(GlobalParameters.projectFilterBorders[0]);
    }
    if (GlobalParameters.projectFilterBorders[1].isNotEmpty) {
      filterYear = int.parse(GlobalParameters.projectFilterBorders[1]);
    }
    if (GlobalParameters.projectFilterBorders[2].isNotEmpty) {
      filterStatus = GlobalParameters.projectFilterBorders[2];
    }
    if (filterMonth == null && filterYear == null && filterStatus == null) {
      return;
    }

    for (int i = projects.length - 1; i >= 0; i--) {
      List<String> tmp = projects[i].date.split(' ');
      int month = ConstantData.appMonths.indexOf(tmp[0]);
      int year = int.parse(tmp[1]);
      String status = projects[i].status;
      if (filterMonth != null) {
        if (filterMonth != month) {
          projects.removeAt(i);
          continue;
        }
      }
      if (filterYear != null) {
        if (filterYear != year) {
          projects.removeAt(i);
          continue;
        }
      }
      if (filterStatus != null) {
        if (filterStatus != status) {
          projects.removeAt(i);
          continue;
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

            aMonth = ConstantData.appMonths.indexOf(aMonth).toString();
            bMonth = ConstantData.appMonths.indexOf(bMonth).toString();
            if (aMonth.length == 1) {
              aMonth = '0' + aMonth;
            }
            if (bMonth.length == 1) {
              bMonth = '0' + bMonth;
            }
            int aDate = int.parse(aYear + aMonth);
            int bDate = int.parse(bYear + bMonth);
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

            aMonth = ConstantData.appMonths.indexOf(aMonth).toString();
            bMonth = ConstantData.appMonths.indexOf(bMonth).toString();
            if (aMonth.length == 1) {
              aMonth = '0' + aMonth;
            }
            if (bMonth.length == 1) {
              bMonth = '0' + bMonth;
            }
            int aDate = int.parse(aYear + aMonth);
            int bDate = int.parse(bYear + bMonth);
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
