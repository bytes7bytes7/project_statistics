import 'package:flutter/material.dart';

import '../widgets/project_mixed_filter.dart';
import '../widgets/project_sort.dart';
import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/project_bloc.dart';
import '../services/measure_beautifier.dart';
import '../models/project.dart';
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
              icon: const Icon(Icons.sort),
              tooltip: ConstantData.appToolTips['sort'],
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ProjectSort();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: ConstantData.appToolTips['filter'],
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ProjectMixedFilter(
                      datesList: GlobalParameters.projectFilterBorders,
                      refresh: () {
                        Bloc.bloc.projectBloc.loadAllProjects();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: _Body(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: ConstantData.appToolTips['add'],
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
        ),
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
    Size size = MediaQuery.of(context).size;
    Size cellSize = Size(180, 40);
    return ValueListenableBuilder(
      valueListenable: update,
      builder: (context, value, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.all(10),
            height: size.height,
            width: cellSize.width * ProjectParameterNames.length,
            child: ListView.builder(
              itemCount: projects.length + 1,
              itemExtent: cellSize.height,
              shrinkWrap: true,
              itemBuilder: (context, rowIndex) {
                return Row(
                  children: List.generate(
                    ProjectParameterNames.length,
                    (columnIndex) {
                      String text = '';
                      Function onTap;
                      bool redLine = false;
                      if (rowIndex == 0) {
                        text = ProjectParameterNames()[columnIndex];
                      } else {
                        if (columnIndex == 0) {
                          text = projects[rowIndex - 1].title;
                        } else if (columnIndex == 1) {
                          text = MeasureBeautifier().truncateZero(
                              (projects[rowIndex - 1].price / 1000000)
                                  .toString());
                        } else if (columnIndex == 2) {
                          text = projects[rowIndex - 1].status;
                          if (text == ProjectStatuses.hot) {
                            redLine = true;
                          }
                        } else if (columnIndex == 3) {
                          text = projects[rowIndex - 1].month +
                              ' ' +
                              projects[rowIndex - 1].year.toString();
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
                        size: cellSize,
                        text: text,
                        onTap: onTap,
                        complete: (rowIndex > 0)
                            ? projects[rowIndex - 1].complete
                            : null,
                        redLine: redLine,
                      );
                    },
                  ),
                );
              },
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
    @required this.size,
    @required this.text,
    @required this.onTap,
    @required this.complete,
    @required this.redLine,
  }) : super(key: key);

  final Size size;
  final String text;
  final Function onTap;
  final String complete;
  final bool redLine;

  @override
  Widget build(BuildContext context) {
    Color color =
        redLine ? Theme.of(context).errorColor : Theme.of(context).shadowColor;
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).disabledColor,
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
