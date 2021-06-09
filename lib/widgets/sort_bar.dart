import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/project.dart';
import '../global/global_parameters.dart';
import '../services/project_sort_service.dart';
import 'flat_wide_button.dart';

class SortBar extends StatelessWidget {
  SortBar({
    Key key,
    @required this.projects,
    @required this.update,
  }) : super(key: key);

  final List<Project> projects;
  final ValueNotifier<bool> update;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            'Сортировка:',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return _SortDialog(
                    update: update,
                    projects: projects,
                  );
                },
              );
            },
            child: Text(
              '${GlobalParameters.projectSortParamName} ${ConstantData.appProjectSortDirection[ConstantData.appProjectParameterDirection.indexOf(GlobalParameters.projectSortParamDirection)]}',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortDialog extends StatefulWidget {
  const _SortDialog({
    Key key,
    @required this.update,
    @required this.projects,
  }) : super(key: key);

  final ValueNotifier<bool> update;
  final List<Project> projects;

  @override
  __SortDialogState createState() => __SortDialogState();
}

class __SortDialogState extends State<_SortDialog> {
  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgets =
        ConstantData.appProjectParameterNames.map<Widget>((e) {
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Radio(
          value: e,
          groupValue: GlobalParameters.projectSortParamName,
          onChanged: (value) {
            setState(() {
              GlobalParameters.projectSortParamName = e;
            });
          },
        ),
        title: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                GlobalParameters.projectSortParamName = e;
              });
            },
            child: Text(
              e,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      );
    }).toList();
    bodyWidgets.add(Divider(thickness: 1));
    bodyWidgets
        .addAll(ConstantData.appProjectParameterDirection.map<Widget>((e) {
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Radio(
          value: e,
          groupValue: GlobalParameters.projectSortParamDirection,
          onChanged: (value) {
            setState(() {
              GlobalParameters.projectSortParamDirection = e;
            });
          },
        ),
        title: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                GlobalParameters.projectSortParamDirection = e;
              });
            },
            child: Text(
              e,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      );
    }).toList());
    bodyWidgets.add(FlatWideButton(
        title: 'Применить',
        onTap: () {
          ProjectSortService.sortProjectsBy(widget.projects);
          widget.update.value = !widget.update.value;
          Navigator.pop(context);
        }));
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Center(
        child: Text(
          'Сортировать по',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: bodyWidgets,
        ),
      ),
    );
  }
}
