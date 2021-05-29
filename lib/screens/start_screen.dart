import 'package:flutter/material.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/bloc/plan_bloc.dart';
import 'package:project_statistics/models/plan.dart';
import 'package:project_statistics/screens/widgets/flat_small_button.dart';
import '../screens/global/global_parameters.dart';
import '../screens/widgets/flat_wide_button.dart';
import '../screens/widgets/input_field.dart';
import '../screens/widgets/outlined_wide_button.dart';
import '../screens/widgets/plan_card.dart';
import 'widgets/loading_circle.dart';

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
              return ContentList(plan: state.plan);
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

class ContentList extends StatefulWidget {
  const ContentList({
    Key key,
    @required this.plan,
  }) : super(key: key);

  final Plan plan;

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  TextEditingController quantityController_1;
  TextEditingController quantityController_2;
  TextEditingController quantityController_3;
  TextEditingController quantityController_4;
  TextEditingController amountController_1;
  TextEditingController amountController_2;
  TextEditingController amountController_3;
  TextEditingController amountController_4;
  TextEditingController periodController;
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
            ? widget.plan.amount[0].toString()
            : '');
    amountController_2 = TextEditingController(
        text: (widget.plan.amount != null)
            ? widget.plan.amount[1].toString()
            : '');
    amountController_3 = TextEditingController(
        text: (widget.plan.amount != null)
            ? widget.plan.amount[2].toString()
            : '');
    amountController_4 = TextEditingController(
        text: (widget.plan.amount != null)
            ? widget.plan.amount[3].toString()
            : '');
    periodController = TextEditingController(text: widget.plan.period ?? '');
    prizeController =
        TextEditingController(text: widget.plan.prize?.toString() ?? '');
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
    periodController.dispose();
    prizeController.dispose();
    super.dispose();
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
            ),
            InputField(
              label: 'КП',
              controller: quantityController_2,
            ),
            InputField(
              label: 'Тендеры',
              controller: quantityController_3,
            ),
            InputField(
              label: 'Договоры',
              controller: quantityController_4,
            ),
          ],
        ),
        PlanCard(
          title: 'Сумма',
          children: [
            InputField(
              label: 'Запросы',
              controller: amountController_1,
            ),
            InputField(
              label: 'КП',
              controller: amountController_2,
            ),
            InputField(
              label: 'Тендеры',
              controller: amountController_3,
            ),
            InputField(
              label: 'Договоры',
              controller: amountController_4,
            ),
          ],
        ),
        PlanCard(
          title: 'Дополнительно',
          children: [
            InputField(
              label: 'Срок',
              controller: periodController,
            ),
            InputField(
              label: 'Премия',
              controller: prizeController,
            ),
          ],
        ),
        OutlinedWideButton(
          title: 'Импорт',
          onTap: () {},
        ),
        OutlinedWideButton(
          title: 'Экспорт',
          onTap: () {},
        ),
        FlatWideButton(
          title: 'Готово',
          onTap: () {
            if (quantityController_1.text.isNotEmpty &&
                quantityController_2.text.isNotEmpty &&
                quantityController_3.text.isNotEmpty &&
                quantityController_4.text.isNotEmpty &&
                amountController_1.text.isNotEmpty &&
                amountController_2.text.isNotEmpty &&
                amountController_3.text.isNotEmpty &&
                amountController_4.text.isNotEmpty &&
                periodController.text.isNotEmpty &&
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
                ..period = periodController.text
                ..prize = double.parse(prizeController.text);
              Bloc.bloc.planBloc.updatePlan(widget.plan);
              GlobalParameters.currentPageIndex.value = 1;
            }
          },
        ),
      ],
    );
  }
}
