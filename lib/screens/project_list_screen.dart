import 'package:flutter/material.dart';

import '../widgets/flat_small_button.dart';
import '../widgets/sort_bar.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/project_bloc.dart';
import '../constants.dart';
import '../models/project.dart';
import '../global/global_parameters.dart';
import 'project_info_screen.dart';

class ProjectListScreen extends StatelessWidget {
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
            icon: const Icon(Icons.view_comfortable),
            onPressed: () {

              GlobalParameters.currentPageIndex.value=-1;

            },
            tooltip: ConstantData.appToolTips['table'],
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
            return _ContentList(projects: state.projects);
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

class _ContentList extends StatelessWidget {
  _ContentList({
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
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: projects.length + 1,
          itemBuilder: (context, i) {
            if (i == 0)
              return SortBar(
                projects: projects,
                update: update,
              );
            else
              return _ProjectCard(
                project: projects[i - 1],
              );
          },
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
