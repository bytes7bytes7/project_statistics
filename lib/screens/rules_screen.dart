import 'package:flutter/material.dart';
import 'package:project_statistics/services/excel_helper.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Правила импорта',
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
      body: Container(
        child: RawScrollbar(
          thumbColor: Theme.of(context).disabledColor.withOpacity(0.5),
          thickness: 7,
          radius: Radius.circular(7),
          child: ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  'Файл Excel должен обязательно содержать лист с названием "Проекты". ' +
                      'На данном листе должна располагаться таблица с проектами. ' +
                      'Первая строка таблицы должна представлять "шапку". ' +
                      'В отдельных ячейках шапки должны быть все поля из списка: ' +
                      'id, Название, Статус, Цена, Месяц, Год, Завершенность .\n\n' +
                      'id - целое число, уникальный номер проекта (Например: 1). ' +
                      'Одинаковых id не должно быть, иначе из серии проектов с одинаковыми id останется только один проект.\n\n'+
                      'Название - строка, имя проекта (Например: Проект 1).\n\n' +
                      'Статус - всего существует 4 статуса: "Запросы", "КП", "Горячие!!!", "Договоры".\n\n' +
                      'Цена - целое число, цена проекта (Например: 1000000).\n\n' +
                      'Месяц - месяц проекта (Например: Февраль).\n\n' +
                      'Год - год проекта (Например: 2021).\n\n' +
                      'Завершенность - всего существует 2 типа: "не завершен", "отменен".\n\n' +
                      'Каждая ячейка должна иметь тип данных "Общий" или "Текстовый". ' +
                      'В каждой ячейке должны быть точные значения - формулы и ссылки запрещены!',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text(
                  'Сохранить пример файла',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  ExcelHelper.saveExample(context);
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
