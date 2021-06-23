import 'package:flutter/material.dart';
import 'package:project_statistics/screens/rules_screen.dart';

import '../services/excel_helper.dart';
import 'show_info_snack_bar.dart';

Future<void> showImportDialog({BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // true - user can dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: Text(
            'Импорт',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Текущие проекты будут удалены!',
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        child: Text(
                          'Правила импорта',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RulesScreen();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'Отмена',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Импорт',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              try {
                                await ExcelHelper.importFromExcel(context);
                              } catch (error) {
                                showInfoSnackBar(
                                  context: context,
                                  info: error.toString(),
                                  icon: Icons.warning_amber_outlined,
                                );
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
