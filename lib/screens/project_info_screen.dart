import 'package:flutter/material.dart';

import '../widgets/double_choice_field.dart';
import '../widgets/choice_field.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/input_field.dart';
import '../widgets/outlined_wide_button.dart';
import '../widgets/show_no_yes_dialog.dart';
import '../global/global_parameters.dart';
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
  TextEditingController dateController;
  TextEditingController completeController;
  ValueNotifier<bool> update;

  @override
  void initState() {
    widget.project.title = widget.project.title ?? '';
    widget.project.status = widget.project.status ?? '';
    widget.project.date = widget.project.date ?? '';
    widget.project.complete =
        widget.project.complete ?? ProjectCompleteStatuses.notCompleted;

    titleController = TextEditingController(text: widget.project.title);
    statusController = TextEditingController(text: widget.project.status);
    priceController =
        TextEditingController(text: widget.project.price?.toString());
    dateController = TextEditingController(text: widget.project.date);
    completeController = TextEditingController(text: widget.project.complete);
    update = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    statusController.dispose();
    priceController.dispose();
    dateController.dispose();
    completeController.dispose();
    super.dispose();
  }

  Future<String> save() async {
    try {
      if (titleController.text.isNotEmpty &&
          statusController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          dateController.text.isNotEmpty &&
          double.parse(priceController.text) >= 0) {
        if (!dateController.text.contains(' ')) {
          return 'Неполная дата';
        }
        widget.project
          ..title = titleController.text
          ..status = statusController.text
          ..price = int.parse(priceController.text)
          ..date = dateController.text
          ..complete = completeController.text;
        if (widget.project.id == null) {
          await Bloc.bloc.projectBloc.addProject(widget.project);
        } else {
          Bloc.bloc.projectBloc.updateProject(widget.project);
        }
        widget.title.value = 'Проект';
        update.value = !update.value;
        return '';
      } else if (priceController.text.isNotEmpty &&
          double.parse(priceController.text) < 0) {
        return 'Сумма отрицательна';
      } else {
        return 'Заполните все поля';
      }
    } catch (error) {
      return 'Ошибка ввода';
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
            FocusScope.of(context).requestFocus(FocusNode());
            if (titleController.text != widget.project.title ||
                statusController.text != widget.project.status ||
                priceController.text != widget.project.price.toString() &&
                    !(!(priceController.text != '') &&
                        !(widget.project.price != null)) ||
                dateController.text != widget.project.date ||
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
              FocusScope.of(context).requestFocus(FocusNode());
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
              FocusScope.of(context).requestFocus(FocusNode());
              String error = await save();
              if (error == '') {
                Navigator.pop(context);
                showInfoSnackBar(
                  context: context,
                  info: 'Сохранено',
                  icon: Icons.done_all_outlined,
                );
              } else {
                showInfoSnackBar(
                  context: context,
                  info: error,
                  icon: Icons.warning_amber_outlined,
                );
              }
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
        dateController: dateController,
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
    @required this.dateController,
    @required this.completeController,
    @required this.update,
    @required this.save,
  }) : super(key: key);

  final Project project;
  final ValueNotifier<String> title;
  final TextEditingController titleController;
  final TextEditingController statusController;
  final TextEditingController priceController;
  final TextEditingController dateController;
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
            ChoiceField(
              label: 'Статус',
              chooseLabel: 'Статус',
              group: ProjectStatuses.values,
              controller: widget.statusController,
            ),
            InputField(
              label: 'Сумма (руб)',
              controller: widget.priceController,
              textInputType: TextInputType.number,
            ),
            DoubleChoiceField(
              label: 'Дата',
              choiceLabel1: 'Месяц',
              choiceLabel2: 'Год',
              group1: ConstantData.appMonths,
              group2: GlobalParameters.planYears,
              controller: widget.dateController,
            ),
            Spacer(),
            ValueListenableBuilder(
              valueListenable: widget.update,
              builder: (context, _, __) {
                if (widget.project.id != null &&
                    widget.completeController.text ==
                        ProjectCompleteStatuses.notCompleted) {
                  return OutlinedWideButton(
                    title: 'Отменить',
                    onTap: () {
                      widget.completeController.text =
                          ProjectCompleteStatuses.canceled;
                      widget.save();
                    },
                  );
                } else if (widget.project.id != null &&
                    widget.completeController.text !=
                        ProjectCompleteStatuses.notCompleted) {
                  return OutlinedWideButton(
                    title: 'Возобновить',
                    onTap: () {
                      widget.completeController.text =
                          ProjectCompleteStatuses.notCompleted;
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
