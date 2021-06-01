import 'package:flutter/material.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/screens/widgets/choose_field.dart';
import 'package:project_statistics/screens/widgets/show_info_snack_bar.dart';
import '../constants.dart';
import '../models/project.dart';
import '../screens/widgets/flat_wide_button.dart';
import '../screens/widgets/input_field.dart';
import '../screens/widgets/outlined_wide_button.dart';
import 'widgets/show_no_yes_dialog.dart';

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
  TextEditingController titleController;
  TextEditingController statusController;
  TextEditingController priceController;
  TextEditingController startPeriodController;
  TextEditingController endPeriodController;

  @override
  void initState() {
    widget.project.title = widget.project.title ?? '';
    widget.project.status = widget.project.status ?? '';
    widget.project.startPeriod = widget.project.startPeriod ?? '';
    widget.project.endPeriod = widget.project.endPeriod ?? '';

    titleController = TextEditingController(text: widget.project.title);
    statusController = TextEditingController(text: widget.project.status);
    priceController = TextEditingController(
        text: (widget.project.price != null)
            ? widget.project.price.toString()
            : '');
    startPeriodController =
        TextEditingController(text: widget.project.startPeriod);
    endPeriodController = TextEditingController(text: widget.project.endPeriod);
    super.initState();
  }

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
            print(titleController.text != widget.project.title);
            print(statusController.text != widget.project.status);
            print(priceController.text !=
                MeasureBeautifier()
                    .truncateZero(widget.project.price.toString()));
            print(startPeriodController.text != widget.project.startPeriod);
            print(endPeriodController.text != widget.project.endPeriod);
            if (titleController.text != widget.project.title ||
                statusController.text != widget.project.status ||
                priceController.text !=
                    MeasureBeautifier()
                        .truncateZero(widget.project.price.toString()) ||
                startPeriodController.text != widget.project.startPeriod ||
                endPeriodController.text != widget.project.endPeriod) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть карту проекта?',
                noAnswer: () {
                  Navigator.pop(context);
                },
                yesAnswer: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _Body(
        project: widget.project,
        title: widget.title,
        titleController: titleController,
        statusController: statusController,
        priceController: priceController,
        startPeriodController: startPeriodController,
        endPeriodController: endPeriodController,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.project,
    @required this.title,
    @required this.titleController,
    @required this.statusController,
    @required this.priceController,
    @required this.startPeriodController,
    @required this.endPeriodController,
  }) : super(key: key);

  final Project project;
  final ValueNotifier<String> title;
  final TextEditingController titleController;
  final TextEditingController statusController;
  final TextEditingController priceController;
  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
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
              controller: widget.titleController,
            ),
            ChooseField(
              label: 'Статус',
              chooseLabel: 'Статус',
              group: ConstantData.appStatus,
              controller: widget.statusController,
            ),
            InputField(
              label: 'Сумма (руб)',
              controller: widget.priceController,
              textInputType: TextInputType.number,
            ),
            Row(
              children: [
                Flexible(
                  child: ChooseField(
                    label: 'Начало',
                    chooseLabel: 'Начало срока',
                    group: ConstantData.appMonths,
                    controller: widget.startPeriodController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: ChooseField(
                    label: 'Конец',
                    chooseLabel: 'Конец срока',
                    group: ConstantData.appMonths,
                    controller: widget.endPeriodController,
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
                if (widget.titleController.text.isNotEmpty &&
                    widget.statusController.text.isNotEmpty &&
                    widget.priceController.text.isNotEmpty &&
                    widget.startPeriodController.text.isNotEmpty &&
                    widget.endPeriodController.text.isNotEmpty &&
                    double.parse(widget.priceController.text) >= 0) {
                  widget.project
                    ..title = widget.titleController.text
                    ..status = widget.statusController.text
                    ..price = int.parse(widget.priceController.text)
                    ..startPeriod = widget.startPeriodController.text
                    ..endPeriod = widget.endPeriodController.text;
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
