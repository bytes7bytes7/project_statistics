import 'package:flutter/material.dart';

import '../widgets/choose_field.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/flat_wide_button.dart';
import '../widgets/input_field.dart';
import '../widgets/outlined_wide_button.dart';
import '../widgets/show_no_yes_dialog.dart';
import '../bloc/bloc.dart';
import '../constants.dart';
import '../models/project.dart';

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
  TextEditingController completeController;
  ValueNotifier<bool> update;

  @override
  void initState() {
    widget.project.title = widget.project.title ?? '';
    widget.project.status = widget.project.status ?? '';
    widget.project.startPeriod = widget.project.startPeriod ?? '';
    widget.project.endPeriod = widget.project.endPeriod ?? '';
    widget.project.complete =
        widget.project.complete ?? ConstantData.projectCompleteStatuses[0];

    titleController = TextEditingController(text: widget.project.title);
    statusController = TextEditingController(text: widget.project.status);
    priceController = TextEditingController(
        text: (widget.project.price != null)
            ? widget.project.price.toString()
            : '');
    startPeriodController =
        TextEditingController(text: widget.project.startPeriod);
    endPeriodController = TextEditingController(text: widget.project.endPeriod);
    completeController = TextEditingController(text: widget.project.complete);
    update = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    statusController.dispose();
    priceController.dispose();
    startPeriodController.dispose();
    endPeriodController.dispose();
    completeController.dispose();
    super.dispose();
  }

  Future save() async {
    if (titleController.text.isNotEmpty &&
        statusController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        startPeriodController.text.isNotEmpty &&
        endPeriodController.text.isNotEmpty &&
        double.parse(priceController.text) >= 0) {
      widget.project
        ..title = titleController.text
        ..status = statusController.text
        ..price = int.parse(priceController.text)
        ..startPeriod = startPeriodController.text
        ..endPeriod = endPeriodController.text
        ..complete = completeController.text;
      if (widget.project.id == null) {
        await Bloc.bloc.projectBloc.addProject(widget.project);
      } else {
        Bloc.bloc.projectBloc.updateProject(widget.project);
      }
      widget.title.value = 'Проект';
      update.value = !update.value;
      showInfoSnackBar(
        context: context,
        info: 'Сохранено',
        icon: Icons.done_all_outlined,
      );
    } else if (priceController.text.isNotEmpty &&
        double.parse(priceController.text) < 0) {
      showInfoSnackBar(
        context: context,
        info: 'Сумма отрицательна',
        icon: Icons.warning_amber_outlined,
      );
    } else {
      showInfoSnackBar(
        context: context,
        info: 'Заполните все поля',
        icon: Icons.warning_amber_outlined,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: widget.title,
          builder: (context, _, __) {
            return Text(
              widget.title.value,
              style: Theme.of(context).textTheme.headline1,
            );
          },
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (titleController.text != widget.project.title ||
                statusController.text != widget.project.status ||
                priceController.text !=
                    MeasureBeautifier()
                        .truncateZero(widget.project.price.toString()) ||
                startPeriodController.text != widget.project.startPeriod ||
                endPeriodController.text != widget.project.endPeriod ||
                completeController.text != widget.project.complete) {
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {
              if (widget.project.id != null) {
                showNoYesDialog(
                  context: context,
                  title: 'Удаление',
                  subtitle: 'Удалить проект?',
                  noAnswer: () {
                    Navigator.of(context).pop();
                  },
                  yesAnswer: () {
                    Bloc.bloc.projectBloc.deleteProject(widget.project.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              } else {
                showInfoSnackBar(
                  context: context,
                  info: 'Проект не создан',
                  icon: Icons.warning_amber_outlined,
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () async {
              save();
            },
          ),
        ],
      ),
      body: _Body(
        project: widget.project,
        title: widget.title,
        titleController: titleController,
        statusController: statusController,
        priceController: priceController,
        startPeriodController: startPeriodController,
        endPeriodController: endPeriodController,
        completeController: completeController,
        update: update,
        save: save,
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
    @required this.completeController,
    @required this.update,
    @required this.save,
  }) : super(key: key);

  final Project project;
  final ValueNotifier<String> title;
  final TextEditingController titleController;
  final TextEditingController statusController;
  final TextEditingController priceController;
  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;
  final TextEditingController completeController;
  final ValueNotifier<bool> update;
  final Function save;

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
            ValueListenableBuilder(
              valueListenable: widget.update,
              builder: (context, _, __) {
                if (widget.project.id != null &&
                    widget.completeController.text ==
                        ConstantData.projectCompleteStatuses[0]) {
                  return Column(
                    children: [
                      OutlinedWideButton(
                        title: 'Отменить',
                        onTap: () {
                          widget.completeController.text =
                              ConstantData.projectCompleteStatuses[2];
                          widget.save();
                        },
                      ),
                      FlatWideButton(
                        title: 'Завершить',
                        onTap: () {
                          widget.completeController.text =
                              ConstantData.projectCompleteStatuses[1];
                          widget.save();
                        },
                      ),
                    ],
                  );
                } else if (widget.project.id != null &&
                    widget.completeController.text !=
                        ConstantData.projectCompleteStatuses[0]) {
                  return OutlinedWideButton(
                    title: 'Возобновить',
                    onTap: () {
                      widget.completeController.text =
                          ConstantData.projectCompleteStatuses[0];
                      widget.save();
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
