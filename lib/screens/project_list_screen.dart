import 'package:flutter/material.dart';
import 'package:project_statistics/widgets/project_filter.dart';

import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/bookmark_clipper.dart';
import '../widgets/project_sort.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/project_bloc.dart';
import '../services/measure_beautifier.dart';
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
              GlobalParameters.currentPageIndex.value = -1;
            },
            tooltip: ConstantData.appToolTips['table'],
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.sort),
            //   tooltip: ConstantData.appToolTips['sort'],
            //   onPressed: () {
            //     showDialog<void>(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return ProjectFilter();
            //       },
            //     );
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.filter_alt_outlined),
            //   tooltip: ConstantData.appToolTips['filter'],
            //   onPressed: () {
            //     showDialog<void>(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return ProjectFilter(
            //           datesList: ,
            //         );
            //       },
            //     );
            //   },
            // ),
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
            return _ContentList(projects: state.projects);
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
          itemCount: projects.length,
          itemBuilder: (context, i) {
            return _ProjectCard(
              project: projects[i],
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
    String price, priceMeasure = 'млн.\nруб.';
    price = MeasureBeautifier()
        .truncateZero((project.price / 1000000).toStringAsFixed(3));
    Size size = Size(double.infinity, 100);
    Color color = (project.status == ProjectStatuses.hot)
        ? Theme.of(context).errorColor
        : Theme.of(context).disabledColor;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Container(
            height: size.height,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                primary: Theme.of(context).focusColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.headline3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 8),
                      Text(
                        priceMeasure,
                        style: Theme.of(context).textTheme.subtitle2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.status,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${project.month} ${project.year}',
                        style: Theme.of(context).textTheme.subtitle2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: ClipPath(
              child: Container(
                height: size.height,
                color:
                    (project.complete == ProjectCompleteStatuses.notCompleted)
                        ? Colors.transparent
                        : Theme.of(context).errorColor,
              ),
              clipper: BookmarkClipper(
                ratio: 0.07,
                offset: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
