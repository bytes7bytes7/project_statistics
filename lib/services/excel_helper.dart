import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../bloc/bloc.dart';
import '../models/project.dart';
import '../widgets/show_info_snack_bar.dart';
import '../constants.dart';
import '../database/database_helper.dart';

abstract class ExcelHelper {
  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;
    var result = await permission.request();
    if (result == PermissionStatus.granted) return true;
    return false;
  }

  static Future<Directory> _getApplicationDirectory(
      BuildContext context) async {
    Directory directory;
    try {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String newPath = '';
        for (String p in directory.path.split('/')) {
          if (p == 'Android')
            break;
          else if (p.isNotEmpty) {
            newPath += '/' + p;
          }
        }
        newPath += '/'+ConstantData.appFolderName;
        directory = Directory(newPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          return directory;
        }
      }
    } catch (error) {
      showInfoSnackBar(
        context: context,
        info: error.toString(),
        icon: Icons.warning_amber_outlined,
      );
    }
    return null;
  }

  static saveExample(BuildContext context)async{
    Directory directory = await _getApplicationDirectory(context);
    String filePath = '${directory.path}/import.xlsx';

    ByteData data = await rootBundle.load("assets/import.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    excel.encode().then(
          (onValue) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      },
    );
    showInfoSnackBar(
      context: context,
      info: '/${ConstantData.appFolderName}/import.xlsx',
      icon: Icons.done_all_outlined,
    );
  }

  static exportToExcel(BuildContext context, String filename) async {
    Directory directory = await _getApplicationDirectory(context);
    String filePath = '${directory.path}/$filename.xlsx';

    // Init excel
    Excel excel = Excel.createExcel();
    excel.copy('Sheet1', ConstDBData.projectTableName.ru);
    excel.delete('Sheet1');

    // Get data
    List<Project> projects = await DatabaseHelper.db.getAllProjects();

    List<String> headerRow;

    // Fill table with data
    for (var table in excel.tables.keys) {
      var thisTable = excel.tables[table];
      List<dynamic> values;
      if (table == ConstDBData.projectTableName.ru) {
        headerRow = Project.getHeaderRow();
        thisTable.appendRow(headerRow);
        for (int i = 0; i < projects.length; i++) {
          values = projects[i].toMap().values.toList();
          thisTable.appendRow(values);
        }
      }

      // Correct quantity of columns
      if (table == ConstDBData.projectTableName.ru) {
        for (int i = 0; i < thisTable.rows.length; i++) {
          while (thisTable.rows[i].length > headerRow.length) {
            thisTable.removeColumn(thisTable.rows[i].length - 1);
          }
        }
      }
    }

    // Save excel
    excel.encode().then(
      (onValue) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      },
    );
    showInfoSnackBar(
      context: context,
      info: 'Экспорт завершен',
      icon: Icons.done_all_outlined,
    );
    Navigator.pop(context);
  }

  static importFromExcel(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Excel excel;
      String file = result.files.single.path;
      Iterable<int> bytes = File(file).readAsBytesSync();
      excel = Excel.decodeBytes(bytes);

      List<Project> projects = <Project>[];
      List<String> headerRow;
      int failedProjects = 0;

      for (var table in excel.tables.keys) {
        var thisTable = excel.tables[table];
        List<dynamic> values;
        if (table == ConstDBData.projectTableName.ru) {
          if (thisTable.rows.length > 0) {
            headerRow =
                thisTable.rows[0].map<String>((e) => e.toString()).toList();
            headerRow = Project.translateToEN(headerRow);
            for (int i = 1; i < thisTable.rows.length; i++) {
              values = thisTable.rows[i];
              Map<String, dynamic> map =
                  Project.formatMap(Map.fromIterables(headerRow, values));
              try {
                if (map != null && map.length > 0) {
                  projects.add(Project.fromMap(map));
                } else {
                  failedProjects++;
                }
              } catch (error) {
                throw error;
              }
            }
          }
        }
      }

      int all = projects.length + failedProjects;

      Bloc.bloc.planBloc.importExcel(projects);
      showInfoSnackBar(
        context: context,
        info: '${projects.length}/$all импортировано',
        icon: Icons.done_all_outlined,
      );
    }
  }
}
