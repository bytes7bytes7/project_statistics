import 'package:flutter/material.dart';
import 'package:project_statistics/widgets/show_no_yes_dialog.dart';

import '../widgets/show_export_dialog.dart';
import '../services/excel_helper.dart';
import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/choose_field.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/flat_wide_button.dart';
import '../widgets/input_field.dart';
import '../widgets/outlined_wide_button.dart';
import '../widgets/plan_card.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/plan_bloc.dart';
import '../database/database_helper.dart';
import '../models/plan.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

class StartScreen extends StatelessWidget {
  final TextEditingController quantityController_1 = TextEditingController();
  final TextEditingController quantityController_2 = TextEditingController();
  final TextEditingController quantityController_3 = TextEditingController();
  final TextEditingController quantityController_4 = TextEditingController();
  final TextEditingController amountController_1 = TextEditingController();
  final TextEditingController amountController_2 = TextEditingController();
  final TextEditingController amountController_3 = TextEditingController();
  final TextEditingController amountController_4 = TextEditingController();
  final TextEditingController startPeriodController = TextEditingController();
  final TextEditingController endPeriodController = TextEditingController();
  final TextEditingController prizeController = TextEditingController();
  final TextEditingController percentController = TextEditingController();
  final TextEditingController ratioController = TextEditingController();

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
            'Создание Плана',
            style: Theme.of(context).textTheme.headline1,
          ),
          leading: IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              showNoYesDialog(
                context: context,
                title: 'Удаление',
                subtitle: 'Удалить все данные?',
                noAnswer: () {
                  Navigator.pop(context);
                },
                yesAnswer: () async {
                  await DatabaseHelper.db.dropBD();
                  quantityController_1.text = '';
                  quantityController_2.text = '';
                  quantityController_3.text = '';
                  quantityController_4.text = '';
                  amountController_1.text = '';
                  amountController_2.text = '';
                  amountController_3.text = '';
                  amountController_4.text = '';
                  startPeriodController.text = '';
                  endPeriodController.text = '';
                  prizeController.text = '';
                  percentController.text = '';
                  ratioController.text = '';
                  showInfoSnackBar(
                    context: context,
                    info: 'Данные удалены',
                    icon: Icons.done_all_outlined,
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: _Body(
          quantityController_1: quantityController_1,
          quantityController_2: quantityController_2,
          quantityController_3: quantityController_3,
          quantityController_4: quantityController_4,
          amountController_1: amountController_1,
          amountController_2: amountController_2,
          amountController_3: amountController_3,
          amountController_4: amountController_4,
          startPeriodController: startPeriodController,
          endPeriodController: endPeriodController,
          prizeController: prizeController,
          percentController: percentController,
          ratioController: ratioController,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.quantityController_1,
    @required this.quantityController_2,
    @required this.quantityController_3,
    @required this.quantityController_4,
    @required this.amountController_1,
    @required this.amountController_2,
    @required this.amountController_3,
    @required this.amountController_4,
    @required this.startPeriodController,
    @required this.endPeriodController,
    @required this.prizeController,
    @required this.percentController,
    @required this.ratioController,
  }) : super(key: key);

  final TextEditingController quantityController_1;
  final TextEditingController quantityController_2;
  final TextEditingController quantityController_3;
  final TextEditingController quantityController_4;
  final TextEditingController amountController_1;
  final TextEditingController amountController_2;
  final TextEditingController amountController_3;
  final TextEditingController amountController_4;
  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;
  final TextEditingController prizeController;
  final TextEditingController percentController;
  final TextEditingController ratioController;

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
      child: StreamBuilder(
        stream: Bloc.bloc.planBloc.plan,
        initialData: PlanInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is PlanInitState) {
            Bloc.bloc.planBloc.loadPlan();
            return SizedBox.shrink();
          } else if (snapshot.data is PlanLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is PlanDataState) {
            PlanDataState state = snapshot.data;
            if (state.plan != null)
              return _ContentList(
                plan: state.plan,
                quantityController_1: widget.quantityController_1,
                quantityController_2: widget.quantityController_2,
                quantityController_3: widget.quantityController_3,
                quantityController_4: widget.quantityController_4,
                amountController_1: widget.amountController_1,
                amountController_2: widget.amountController_2,
                amountController_3: widget.amountController_3,
                amountController_4: widget.amountController_4,
                startPeriodController: widget.startPeriodController,
                endPeriodController: widget.endPeriodController,
                prizeController: widget.prizeController,
                percentController: widget.percentController,
                ratioController: widget.ratioController,
              );
            else
              return EmptyLabel();
          } else {
            return ErrorLabel(
              error: snapshot.data.error,
              stackTrace: snapshot.data.stackTrace,
              onPressed: () {
                Bloc.bloc.planBloc.loadPlan();
              },
            );
          }
        },
      ),
    );
  }
}

class _ContentList extends StatefulWidget {
  const _ContentList({
    Key key,
    @required this.plan,
    @required this.quantityController_1,
    @required this.quantityController_2,
    @required this.quantityController_3,
    @required this.quantityController_4,
    @required this.amountController_1,
    @required this.amountController_2,
    @required this.amountController_3,
    @required this.amountController_4,
    @required this.startPeriodController,
    @required this.endPeriodController,
    @required this.prizeController,
    @required this.percentController,
    @required this.ratioController,
  }) : super(key: key);

  final Plan plan;
  final TextEditingController quantityController_1;
  final TextEditingController quantityController_2;
  final TextEditingController quantityController_3;
  final TextEditingController quantityController_4;
  final TextEditingController amountController_1;
  final TextEditingController amountController_2;
  final TextEditingController amountController_3;
  final TextEditingController amountController_4;
  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;
  final TextEditingController prizeController;
  final TextEditingController percentController;
  final TextEditingController ratioController;

  @override
  __ContentListState createState() => __ContentListState();
}

class __ContentListState extends State<_ContentList> {
  @override
  void initState() {
    widget.quantityController_1.text = (widget.plan.quantity != null)
        ? widget.plan.quantity[0].toString()
        : '';
    widget.quantityController_2.text = (widget.plan.quantity != null)
        ? widget.plan.quantity[1].toString()
        : '';
    widget.quantityController_3.text = (widget.plan.quantity != null)
        ? widget.plan.quantity[2].toString()
        : '';
    widget.quantityController_4.text = (widget.plan.quantity != null)
        ? widget.plan.quantity[3].toString()
        : '';
    widget.amountController_1.text = (widget.plan.amount != null)
        ? MeasureBeautifier().truncateZero(widget.plan.amount[0].toString())
        : '';
    widget.amountController_2.text = (widget.plan.amount != null)
        ? MeasureBeautifier().truncateZero(widget.plan.amount[1].toString())
        : '';
    widget.amountController_3.text = (widget.plan.amount != null)
        ? MeasureBeautifier().truncateZero(widget.plan.amount[2].toString())
        : '';
    widget.amountController_4.text = (widget.plan.amount != null)
        ? MeasureBeautifier().truncateZero(widget.plan.amount[3].toString())
        : '';
    widget.startPeriodController.text = widget.plan.startPeriod;
    widget.endPeriodController.text = widget.plan.endPeriod;
    widget.prizeController.text = (widget.plan.prize != null)
        ? MeasureBeautifier().truncateZero(widget.plan.prize.toString())
        : '';
    widget.percentController.text = (widget.plan.percent != null)
        ? MeasureBeautifier().truncateZero(widget.plan.percent.toString())
        : '';
    widget.ratioController.text = (widget.plan.ratio != null)
        ? MeasureBeautifier().truncateZero(widget.plan.ratio.toString())
        : '';
    super.initState();
  }

  Future<bool> save() async {
    if (widget.quantityController_1.text.isNotEmpty &&
        widget.quantityController_2.text.isNotEmpty &&
        widget.quantityController_3.text.isNotEmpty &&
        widget.quantityController_4.text.isNotEmpty &&
        widget.amountController_1.text.isNotEmpty &&
        widget.amountController_2.text.isNotEmpty &&
        widget.amountController_3.text.isNotEmpty &&
        widget.amountController_4.text.isNotEmpty &&
        widget.startPeriodController.text.isNotEmpty &&
        widget.endPeriodController.text.isNotEmpty &&
        widget.prizeController.text.isNotEmpty &&
        widget.percentController.text.isNotEmpty &&
        widget.ratioController.text.isNotEmpty) {
      widget.plan
        ..quantity = [
          int.parse(widget.quantityController_1.text),
          int.parse(widget.quantityController_2.text),
          int.parse(widget.quantityController_3.text),
          int.parse(widget.quantityController_4.text),
        ]
        ..amount = [
          double.parse(widget.amountController_1.text),
          double.parse(widget.amountController_2.text),
          double.parse(widget.amountController_3.text),
          double.parse(widget.amountController_4.text),
        ]
        ..startPeriod = widget.startPeriodController.text
        ..endPeriod = widget.endPeriodController.text
        ..prize = double.parse(widget.prizeController.text)
        ..percent = double.parse(widget.percentController.text)
        ..ratio = double.parse(widget.ratioController.text);
      Bloc.bloc.planBloc.updatePlan(widget.plan);
      return true;
    } else {
      showInfoSnackBar(
        context: context,
        info: 'Заполните все поля',
        icon: Icons.warning_amber_outlined,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      children: [
        PlanCard(
          title: 'Количество',
          children: [
            InputField(
              label: 'Запросы',
              controller: widget.quantityController_1,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[0] =
                      int.parse(widget.quantityController_1.text);
              },
            ),
            InputField(
              label: 'КП',
              controller: widget.quantityController_2,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[1] =
                      int.parse(widget.quantityController_2.text);
              },
            ),
            InputField(
              label: 'Тендеры',
              controller: widget.quantityController_3,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[2] =
                      int.parse(widget.quantityController_3.text);
              },
            ),
            InputField(
              label: 'Договоры',
              controller: widget.quantityController_4,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[3] =
                      int.parse(widget.quantityController_4.text);
              },
            ),
          ],
        ),
        PlanCard(
          title: 'Сумма',
          children: [
            InputField(
              label: 'Запросы (млн руб)',
              controller: widget.amountController_1,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[0] =
                      double.parse(widget.amountController_1.text);
              },
            ),
            InputField(
              label: 'КП (млн руб)',
              controller: widget.amountController_2,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[1] =
                      double.parse(widget.amountController_2.text);
              },
            ),
            InputField(
              label: 'Тендеры (млн руб)',
              controller: widget.amountController_3,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[2] =
                      double.parse(widget.amountController_3.text);
              },
            ),
            InputField(
              label: 'Договоры (млн руб)',
              controller: widget.amountController_4,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[3] =
                      double.parse(widget.amountController_4.text);
              },
            ),
          ],
        ),
        PlanCard(
          title: 'Дополнительно',
          children: [
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
            InputField(
              label: 'Премия (тыс руб)',
              controller: widget.prizeController,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.prize =
                      double.parse(widget.prizeController.text);
              },
            ),
            InputField(
              label: 'Стартовый %',
              controller: widget.percentController,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.percent =
                      double.parse(widget.percentController.text);
              },
            ),
            InputField(
              label: 'Коэффициент',
              controller: widget.ratioController,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.ratio =
                      double.parse(widget.ratioController.text);
              },
            ),
          ],
        ),
        OutlinedWideButton(
          title: 'Импорт',
          onTap: () {
            ExcelHelper.importFromExcel(context);
          },
        ),
        OutlinedWideButton(
          title: 'Экспорт',
          onTap: () async {
            if (await save()) {
              showExportDialog(context: context);
            }
          },
        ),
        FlatWideButton(
          title: 'Готово',
          onTap: () async {
            await save();
            GlobalParameters.currentPageIndex.value = 1;
          },
        ),
      ],
    );
  }
}
