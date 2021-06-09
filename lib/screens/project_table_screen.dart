import 'package:flutter/material.dart';

import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/project_bloc.dart';
import '../models/project.dart';
import '../services/project_sort_service.dart';
import '../constants.dart';
import '../global/global_parameters.dart';
import 'project_info_screen.dart';

class ProjectTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Проекты',
            style: Theme.of(context).textTheme.headline1,
          ),
          leading: IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              GlobalParameters.currentPageIndex.value = 1;
            },
            tooltip: ConstantData.appToolTips['list'],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProjectInfoScreen(
                      str: 'Новый Проект',
                      project: Project(),
                    );
                  }),
                );
              },
              tooltip: ConstantData.appToolTips['add'],
            ),
          ],
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Bloc.bloc.projectBloc.project,
      initialData: ProjectInitState(),
      builder: (context, snapshot) {
        if (snapshot.data is ProjectInitState) {
          Bloc.bloc.projectBloc.loadAllProjects();
          return SizedBox.shrink();
        } else if (snapshot.data is ProjectLoadingState) {
          return LoadingCircle();
        } else if (snapshot.data is ProjectDataState) {
          ProjectDataState state = snapshot.data;
          if (state.projects.length > 0)
            return _ContentTable(projects: state.projects);
          else
            return EmptyLabel();
        } else {
          return ErrorLabel(
            error: snapshot.data.error,
            stackTrace: snapshot.data.stackTrace,
            onPressed: () {
              Bloc.bloc.projectBloc.loadAllProjects();
            },
          );
        }
      },
    );
  }
}

class _ContentTable extends StatelessWidget {
  _ContentTable({
    Key key,
    @required this.projects,
  }) : super(key: key);

  final List<Project> projects;
  final ValueNotifier<bool> update = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: update,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        projects.length + 1,
                        (rowIndex) {
                          return Row(
                            children: List.generate(
                              ConstantData.appProjectParameterNames.length,
                              (columnIndex) {
                                String text;
                                Function onTap;
                                if (rowIndex == 0) {
                                  text = ConstantData
                                      .appProjectParameterNames[columnIndex];
                                  if (columnIndex ==
                                      ConstantData.appProjectParameterNames
                                          .indexOf(GlobalParameters
                                              .projectSortParamName)) {
                                    text += ' ' +
                                        ConstantData.appProjectSortDirection[
                                            ConstantData
                                                .appProjectParameterDirection
                                                .indexOf(GlobalParameters
                                                    .projectSortParamDirection)];
                                  }
                                  onTap = () {
                                    if (columnIndex ==
                                        ConstantData.appProjectParameterNames
                                            .indexOf(GlobalParameters
                                                .projectSortParamName)) {
                                      GlobalParameters
                                          .projectSortParamDirection = ConstantData
                                              .appProjectParameterDirection[
                                          (ConstantData
                                                      .appProjectParameterDirection
                                                      .indexOf(GlobalParameters
                                                          .projectSortParamDirection) -
                                                  1)
                                              .abs()];
                                    } else {
                                      GlobalParameters.projectSortParamName =
                                          text;
                                    }
                                    ProjectSortService.sortProjectsBy(projects);
                                    update.value = !update.value;
                                  };
                                } else {
                                  if (columnIndex == 0) {
                                    text = projects[rowIndex - 1].title;
                                  } else if (columnIndex == 1) {
                                    text =
                                        projects[rowIndex - 1].price.toString();
                                  } else if (columnIndex == 2) {
                                    text = projects[rowIndex - 1].status;
                                  } else if (columnIndex == 3) {
                                    text =
                                        '${projects[rowIndex - 1].startPeriod} - ${projects[rowIndex - 1].endPeriod}';
                                  } else {
                                    text = projects[rowIndex - 1].complete;
                                  }
                                  onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProjectInfoScreen(
                                            str: 'Проект',
                                            project: projects[rowIndex - 1],
                                          );
                                        },
                                      ),
                                    );
                                  };
                                }
                                return _ProjectCell(
                                  text: text,
                                  onTap: onTap,
                                  complete: (rowIndex > 0)
                                      ? projects[rowIndex - 1].complete
                                      : null,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectCell extends StatelessWidget {
  const _ProjectCell({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.complete,
  }) : super(key: key);

  final String text;
  final Function onTap;
  final String complete;

  @override
  Widget build(BuildContext context) {
    // Size size = Size(170, 40);
    // return Material(
    //   child: InkWell(
    //     onTap: onTap,
    //     child: Container(
    //       margin: EdgeInsets.all(0),
    //       height: size.height,
    //       width: size.width,
    //       child: Stack(
    //         children: [
    //           Container(
    //             alignment: Alignment.center,
    //             padding: const EdgeInsets.symmetric(horizontal: 4),
    //             height: size.height,
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Theme.of(context).focusColor,
    //               border: Border.all(
    //                 color: Theme.of(context).shadowColor.withOpacity(0.2),
    //               ),
    //             ),
    //             child: Text(
    //               text,
    //               style: Theme.of(context).textTheme.bodyText2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //           Positioned(
    //             child: ClipPath(
    //               child: Container(
    //                 height: size.height,
    //                 color: (complete == null)
    //                     ? Colors.transparent
    //                     : (complete == ConstantData.projectCompleteStatuses[0])
    //                         ? Colors.transparent
    //                         : (complete ==
    //                                 ConstantData.projectCompleteStatuses[1])
    //                             ? Theme.of(context).primaryColor
    //                             : Theme.of(context).errorColor,
    //               ),
    //               clipper: BookmarkClipper(
    //                 ratio: 0.07,
    //                 offset: 5,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          width: 170.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: (complete == ConstantData.projectCompleteStatuses[1])
                ? Theme.of(context).primaryColor.withOpacity(0.4)
                : (complete == ConstantData.projectCompleteStatuses[2])
                    ? Theme.of(context).errorColor.withOpacity(0.4)
                    : Theme.of(context).focusColor,
            border: Border.all(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
