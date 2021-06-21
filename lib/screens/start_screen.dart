import 'package:flutter/material.dart';

import '../widgets/choice_field.dart';
import '../widgets/show_no_yes_dialog.dart';
import '../widgets/show_export_dialog.dart';
import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/flat_wide_button.dart';
import '../widgets/input_field.dart';
import '../widgets/outlined_wide_button.dart';
import '../widgets/plan_card.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/plan_bloc.dart';
import '../services/excel_helper.dart';
import '../services/measure_beautifier.dart';
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
  final TextEditingController startMonthController = TextEditingController();
  final TextEditingController startYearController = TextEditingController();
  final TextEditingController endMonthController = TextEditingController();
  final TextEditingController endYearController = TextEditingController();
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
            'План',
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
                  startMonthController.text = '';
                  startYearController.text = '';
                  endMonthController.text = '';
                  endYearController.text = '';
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
          startMonthController: startMonthController,
          startYearController: startYearController,
          endMonthController: endMonthController,
          endYearController: endYearController,
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
    @required this.startMonthController,
    @required this.startYearController,
    @required this.endMonthController,
    @required this.endYearController,
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
  final TextEditingController startMonthController;
  final TextEditingController startYearController;
  final TextEditingController endMonthController;
  final TextEditingController endYearController;
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
                startMonthController: widget.startMonthController,
                startYearController: widget.startYearController,
                endMonthController: widget.endMonthController,
                endYearController: widget.endYearController,
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
    @required this.startMonthController,
    @required this.startYearController,
    @required this.endMonthController,
    @required this.endYearController,
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
  final TextEditingController startMonthController;
  final TextEditingController startYearController;
  final TextEditingController endMonthController;
  final TextEditingController endYearController;
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
    widget.startMonthController.text = (widget.plan.startMonth != null)
        ? widget.plan.startMonth.toString()
        : '';
    widget.startYearController.text =
        (widget.plan.startYear != null) ? widget.plan.startYear.toString() : '';
    widget.endMonthController.text =
        (widget.plan.endMonth != null) ? widget.plan.endMonth.toString() : '';
    widget.endYearController.text =
        (widget.plan.endYear != null) ? widget.plan.endYear.toString() : '';
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

  Future<String> save() async {
    if (widget.quantityController_1.text.isNotEmpty &&
        widget.quantityController_2.text.isNotEmpty &&
        widget.quantityController_3.text.isNotEmpty &&
        widget.quantityController_4.text.isNotEmpty &&
        widget.amountController_1.text.isNotEmpty &&
        widget.amountController_2.text.isNotEmpty &&
        widget.amountController_3.text.isNotEmpty &&
        widget.amountController_4.text.isNotEmpty &&
        widget.startMonthController.text.isNotEmpty &&
        widget.startYearController.text.isNotEmpty &&
        widget.endMonthController.text.isNotEmpty &&
        widget.endYearController.text.isNotEmpty &&
        widget.prizeController.text.isNotEmpty &&
        widget.percentController.text.isNotEmpty &&
        widget.ratioController.text.isNotEmpty) {
      try {
        widget.prizeController.text =
            widget.prizeController.text.replaceAll(',', '.');
        widget.percentController.text =
            widget.percentController.text.replaceAll(',', '.');
        widget.ratioController.text =
            widget.ratioController.text.replaceAll(',', '.');
        widget.plan
          ..quantity = [
            int.parse(widget.quantityController_1.text.replaceAll(' ', '')),
            int.parse(widget.quantityController_2.text.replaceAll(' ', '')),
            int.parse(widget.quantityController_3.text.replaceAll(' ', '')),
            int.parse(widget.quantityController_4.text.replaceAll(' ', '')),
          ]
          ..amount = [
            int.parse(widget.amountController_1.text.replaceAll(' ', '')),
            int.parse(widget.amountController_2.text.replaceAll(' ', '')),
            int.parse(widget.amountController_3.text.replaceAll(' ', '')),
            int.parse(widget.amountController_4.text.replaceAll(' ', '')),
          ]
          ..startMonth = widget.startMonthController.text
          ..startYear = int.parse(widget.startYearController.text)
          ..endMonth = widget.endMonthController.text
          ..endYear = int.parse(widget.endYearController.text)
          ..prize =
              double.parse(widget.prizeController.text.replaceAll(' ', ''))
          ..percent =
              double.parse(widget.percentController.text.replaceAll(' ', ''))
          ..ratio =
              double.parse(widget.ratioController.text.replaceAll(' ', ''));
        Bloc.bloc.planBloc.updatePlan(widget.plan);
      } catch (error) {
        return 'Ошибка ввода';
      }
      return '';
    } else {
      return 'Заполните все поля';
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
            ),
            InputField(
              label: 'КП',
              controller: widget.quantityController_2,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Горячие!!!',
              controller: widget.quantityController_3,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Договоры',
              controller: widget.quantityController_4,
              textInputType: TextInputType.number,
            ),
          ],
        ),
        PlanCard(
          title: 'Сумма',
          children: [
            InputField(
              label: 'Запросы (руб)',
              controller: widget.amountController_1,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'КП (руб)',
              controller: widget.amountController_2,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Горячие!!! (руб)',
              controller: widget.amountController_3,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Договоры (руб)',
              controller: widget.amountController_4,
              textInputType: TextInputType.number,
            ),
          ],
        ),
        PlanCard(
          title: 'Дополнительно',
          children: [
            Row(
              children: [
                Flexible(
                  child: ChoiceField(
                    label: 'Месяц',
                    chooseLabel: 'Начало: Месяц',
                    group: ConstantData.appMonths,
                    controller: widget.startMonthController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: InputField(
                    label: 'Год',
                    controller: widget.startYearController,
                    textInputType: TextInputType.number,
                    amountFormatter: false,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ChoiceField(
                    label: 'Месяц',
                    chooseLabel: 'Конец: Месяц',
                    group: ConstantData.appMonths,
                    controller: widget.endMonthController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: InputField(
                    label: 'Год',
                    controller: widget.endYearController,
                    textInputType: TextInputType.number,
                    amountFormatter: false,
                  ),
                ),
              ],
            ),
            InputField(
              label: 'Премия за выполнение (руб)',
              controller: widget.prizeController,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Минимальный % выполнения',
              controller: widget.percentController,
              textInputType: TextInputType.number,
            ),
            InputField(
              label: 'Коэффициент за перевыполнение',
              controller: widget.ratioController,
              textInputType: TextInputType.number,
            ),
          ],
        ),
        OutlinedWideButton(
          title: 'Импорт',
          onTap: () async {
            // Change locale to RU
            ConstDBData.locale = 'ru';
            try {
              await ExcelHelper.importFromExcel(context);
            } catch (error) {
              showInfoSnackBar(
                context: context,
                info: error.toString(),
                icon: Icons.warning_amber_outlined,
              );
            }
            // Change locale to RU
            ConstDBData.locale = 'en';
          },
        ),
        OutlinedWideButton(
          title: 'Экспорт',
          onTap: () async {
            String result = await save();
            if (result.isEmpty) {
              showExportDialog(context: context);
            } else {
              showInfoSnackBar(
                context: context,
                info: result,
                icon: Icons.warning_amber_outlined,
              );
            }
          },
        ),
        FlatWideButton(
          title: 'Сохранить',
          onTap: () async {
            String result = await save();
            if (result.isEmpty) {
              GlobalParameters.currentPageIndex.value = 1;
            } else {
              showInfoSnackBar(
                context: context,
                info: result,
                icon: Icons.warning_amber_outlined,
              );
            }
          },
        ),
      ],
    );
  }
}
