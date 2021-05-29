import 'package:flutter/material.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/screens/widgets/choose_field.dart';
import 'package:project_statistics/screens/widgets/show_info_snack_bar.dart';
import '../constants.dart';
import '../models/project.dart';
import '../screens/widgets/flat_wide_button.dart';
import '../screens/widgets/input_field.dart';
import '../screens/widgets/outlined_wide_button.dart';

class ProjectInfoScreen extends StatefulWidget {
  ProjectInfoScreen({
    Key key,
    @required String str,
    @required this.project,
  })  : title = ValueNotifier(str),
        super(key: key);

  final ValueNotifier<String> title;
  final Project project;

  @override
  _ProjectInfoScreenState createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title.value,
          style: Theme.of(context).textTheme.headline1,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _Body(
        project: widget.project,
        title: widget.title,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.project,
    @required this.title,
  }) : super(key: key);

  final Project project;
  final ValueNotifier<String> title;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  TextEditingController titleController;
  TextEditingController statusController;
  TextEditingController priceController;
  TextEditingController startPeriodController;
  TextEditingController endPeriodController;

  @override
  void initState() {
    titleController = TextEditingController(
        text: (widget.project.title != null) ? widget.project.title : '');
    statusController = TextEditingController(
        text: (widget.project.status != null) ? widget.project.status : '');
    priceController = TextEditingController(
        text: (widget.project.price != null) ? widget.project.price.toString() : '');
    startPeriodController = TextEditingController(
        text: (widget.project.startPeriod != null)
            ? widget.project.startPeriod
            : '');
    endPeriodController = TextEditingController(
        text:
            (widget.project.endPeriod != null) ? widget.project.endPeriod : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            InputField(
              label: 'Название',
              controller: titleController,
            ),
            ChooseField(
              label: 'Статус',
              chooseLabel: 'Статус',
              group: ConstantData.appStatus,
              controller: statusController,
            ),
            InputField(
              label: 'Сумма',
              controller: priceController,
              textInputType: TextInputType.number,
            ),
            Row(
              children: [
                Flexible(
                  child: ChooseField(
                    label: 'Начало',
                    chooseLabel: 'Начало срока',
                    group: ConstantData.appMonths,
                    controller: startPeriodController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: ChooseField(
                    label: 'Конец',
                    chooseLabel: 'Конец срока',
                    group: ConstantData.appMonths,
                    controller: endPeriodController,
                  ),
                ),
              ],
            ),
            Spacer(),
            OutlinedWideButton(
              title: 'Удалить',
              onTap: () {
                if (widget.project.id != null) {
                  Bloc.bloc.projectBloc.deleteProject(widget.project.id);
                  Navigator.pop(context);
                } else {
                  showInfoSnackBar(
                    context: context,
                    info: 'Проект не создан',
                    icon: Icons.warning_amber_outlined,
                  );
                }
              },
            ),
            FlatWideButton(
              title: 'Готово',
              onTap: () {
                if (titleController.text.isNotEmpty &&
                    statusController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    startPeriodController.text.isNotEmpty &&
                    endPeriodController.text.isNotEmpty) {
                  widget.project
                    ..title = titleController.text
                    ..status = statusController.text
                    ..price = int.parse(priceController.text)
                    ..startPeriod = startPeriodController.text
                    ..endPeriod = endPeriodController.text;
                  if (widget.project.id == null) {
                    Bloc.bloc.projectBloc.addProject(widget.project);
                  } else {
                    Bloc.bloc.projectBloc.updateProject(widget.project);
                  }
                  showInfoSnackBar(
                    context: context,
                    info: 'Сохранено',
                    icon: Icons.done_all_outlined,
                  );
                } else {
                  showInfoSnackBar(
                    context: context,
                    info: 'Заполните все поля',
                    icon: Icons.warning_amber_outlined,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
