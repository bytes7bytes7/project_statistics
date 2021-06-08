import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../bloc/project_bloc.dart';
import '../widgets/flat_small_button.dart';
import '../widgets/loading_circle.dart';
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
  // @override
  // void dispose() {
  //   Bloc.bloc.projectBloc.dispose();
  //   super.dispose();
  // }

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
          return _buildLoading();
        } else if (snapshot.data is ProjectDataState) {
          ProjectDataState state = snapshot.data;
          if (state.projects.length > 0)
            return _ContentTable(projects: state.projects);
          else
            return Center(
              child: Text(
                'Пусто',
                style: Theme.of(context).textTheme.headline2,
              ),
            );
        } else {
          return _buildError();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingCircle(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 20),
          FlatSmallButton(
            title: 'Обновить',
            onTap: () {
              Bloc.bloc.projectBloc.loadAllProjects();
            },
          ),
        ],
      ),
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
                                  } else {
                                    text =
                                        '${projects[rowIndex - 1].startPeriod} - ${projects[rowIndex - 1].endPeriod}';
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
                                return Material(
                                  child: InkWell(
                                    onTap: onTap,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(0),
                                      width: 140.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).focusColor,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ),
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

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    Key key,
    @required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ProjectInfoScreen(
                str: 'Проект',
                project: project,
              );
            }),
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                Text(
                  '${project.price} ₽',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  project.status,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Spacer(),
                Text(
                  '${project.startPeriod} - ${project.endPeriod}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
