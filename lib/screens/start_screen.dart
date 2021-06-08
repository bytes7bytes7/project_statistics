import 'package:flutter/material.dart';
import 'package:project_statistics/services/excel_helper.dart';

import '../widgets/choose_field.dart';
import '../widgets/flat_small_button.dart';
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
              DatabaseHelper.db.dropBD();
            },
          ),
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
            return _buildLoading();
          } else if (snapshot.data is PlanDataState) {
            PlanDataState state = snapshot.data;
            if (state.plan != null)
              return _ContentList(plan: state.plan);
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
      ),
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
              Bloc.bloc.planBloc.loadPlan();
            },
          ),
        ],
      ),
    );
  }
}

class _ContentList extends StatefulWidget {
  const _ContentList({
    Key key,
    @required this.plan,
  }) : super(key: key);

  final Plan plan;

  @override
  __ContentListState createState() => __ContentListState();
}

class __ContentListState extends State<_ContentList> {
  TextEditingController quantityController_1;
  TextEditingController quantityController_2;
  TextEditingController quantityController_3;
  TextEditingController quantityController_4;
  TextEditingController amountController_1;
  TextEditingController amountController_2;
  TextEditingController amountController_3;
  TextEditingController amountController_4;
  TextEditingController startPeriodController;
  TextEditingController endPeriodController;
  TextEditingController prizeController;

  @override
  void initState() {
    quantityController_1 = TextEditingController(
        text: (widget.plan.quantity != null)
            ? widget.plan.quantity[0].toString()
            : '');
    quantityController_2 = TextEditingController(
        text: (widget.plan.quantity != null)
            ? widget.plan.quantity[1].toString()
            : '');
    quantityController_3 = TextEditingController(
        text: (widget.plan.quantity != null)
            ? widget.plan.quantity[2].toString()
            : '');
    quantityController_4 = TextEditingController(
        text: (widget.plan.quantity != null)
            ? widget.plan.quantity[3].toString()
            : '');
    amountController_1 = TextEditingController(
        text: (widget.plan.amount != null)
            ? MeasureBeautifier().truncateZero(widget.plan.amount[0].toString())
            : '');
    amountController_2 = TextEditingController(
        text: (widget.plan.amount != null)
            ? MeasureBeautifier().truncateZero(widget.plan.amount[1].toString())
            : '');
    amountController_3 = TextEditingController(
        text: (widget.plan.amount != null)
            ? MeasureBeautifier().truncateZero(widget.plan.amount[2].toString())
            : '');
    amountController_4 = TextEditingController(
        text: (widget.plan.amount != null)
            ? MeasureBeautifier().truncateZero(widget.plan.amount[3].toString())
            : '');
    startPeriodController =
        TextEditingController(text: widget.plan.startPeriod);
    endPeriodController = TextEditingController(text: widget.plan.endPeriod);
    prizeController = TextEditingController(
        text: (widget.plan.prize != null)
            ? MeasureBeautifier().truncateZero(widget.plan.prize.toString())
            : '');
    super.initState();
  }

  @override
  void dispose() {
    Bloc.bloc.planBloc.dispose();
    quantityController_1.dispose();
    quantityController_2.dispose();
    quantityController_3.dispose();
    quantityController_4.dispose();
    amountController_1.dispose();
    amountController_2.dispose();
    amountController_3.dispose();
    amountController_4.dispose();
    startPeriodController.dispose();
    endPeriodController.dispose();
    prizeController.dispose();
    super.dispose();
  }

  Future<bool> save() async {
    if (quantityController_1.text.isNotEmpty &&
        quantityController_2.text.isNotEmpty &&
        quantityController_3.text.isNotEmpty &&
        quantityController_4.text.isNotEmpty &&
        amountController_1.text.isNotEmpty &&
        amountController_2.text.isNotEmpty &&
        amountController_3.text.isNotEmpty &&
        amountController_4.text.isNotEmpty &&
        startPeriodController.text.isNotEmpty &&
        endPeriodController.text.isNotEmpty &&
        prizeController.text.isNotEmpty) {
      widget.plan
        ..quantity = [
          int.parse(quantityController_1.text),
          int.parse(quantityController_2.text),
          int.parse(quantityController_3.text),
          int.parse(quantityController_4.text),
        ]
        ..amount = [
          double.parse(amountController_1.text),
          double.parse(amountController_2.text),
          double.parse(amountController_3.text),
          double.parse(amountController_4.text),
        ]
        ..startPeriod = startPeriodController.text
        ..endPeriod = endPeriodController.text
        ..prize = double.parse(prizeController.text);
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
              controller: quantityController_1,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[0] =
                      int.parse(quantityController_1.text);
              },
            ),
            InputField(
              label: 'КП',
              controller: quantityController_2,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[1] =
                      int.parse(quantityController_2.text);
              },
            ),
            InputField(
              label: 'Тендеры',
              controller: quantityController_3,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[2] =
                      int.parse(quantityController_3.text);
              },
            ),
            InputField(
              label: 'Договоры',
              controller: quantityController_4,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.quantity[3] =
                      int.parse(quantityController_4.text);
              },
            ),
          ],
        ),
        PlanCard(
          title: 'Сумма',
          children: [
            InputField(
              label: 'Запросы (млн руб)',
              controller: amountController_1,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[0] =
                      double.parse(amountController_1.text);
              },
            ),
            InputField(
              label: 'КП (млн руб)',
              controller: amountController_2,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[1] =
                      double.parse(amountController_2.text);
              },
            ),
            InputField(
              label: 'Тендеры (млн руб)',
              controller: amountController_3,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[2] =
                      double.parse(amountController_3.text);
              },
            ),
            InputField(
              label: 'Договоры (млн руб)',
              controller: amountController_4,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.amount[3] =
                      double.parse(amountController_4.text);
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
            InputField(
              label: 'Премия (тыс руб)',
              controller: prizeController,
              textInputType: TextInputType.number,
              update: (dynamic value) {
                if (value != null)
                  GlobalParameters.newPlan.prize =
                      double.parse(prizeController.text);
              },
            ),
          ],
        ),
        OutlinedWideButton(
          title: 'Импорт',
          onTap: () {},
        ),
        OutlinedWideButton(
          title: 'Экспорт',
          onTap: () async{
            // TODO: check if plan exists before export data
            if(await save()){
              ExcelHelper.exportToExcel(context, 'filename');
            }
          },
        ),
        FlatWideButton(
          title: 'Готово',
          onTap: () {
            save();
            GlobalParameters.currentPageIndex.value = 1;
          },
        ),
      ],
    );
  }
}
