import 'package:flutter/material.dart';
import '../models/project.dart';
import '../screens/widgets/flat_wide_button.dart';
import '../screens/widgets/input_field.dart';
import '../screens/widgets/outlined_wide_button.dart';

class ProjectInfoScreen extends StatefulWidget {
  const ProjectInfoScreen({
    Key key,
    @required this.title,
    @required this.project,
  }) : super(key: key);

  final String title;
  final Project project;

  @override
  _ProjectInfoScreenState createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  String _title;

  @override
  void initState() {
    _title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _title,
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
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
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
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Статус',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Сумма',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Срок',
              controller: TextEditingController(),
            ),
            Spacer(),
            OutlinedWideButton(
              title: 'Удалить',
              onTap: () {},
            ),
            FlatWideButton(
              title: 'Готово',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
