import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class ExcelHelper {
  static readExcel() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String file = result.files.single.path;
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        print(table);
        print(excel.tables[table].maxCols);
        print(excel.tables[table].maxRows);
        for (var row in excel.tables[table].rows) {
          print("$row");
        }
      }
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static createAppFolder() async {
    Directory directory;
    if (await _requestPermission(Permission.storage)) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/RPSApp";
      directory = Directory(newPath);
      print(directory);
    } else {
      return false;
    }
    bool exists = await directory.exists();
    print(exists);
    if (exists==false) {
      print('start');
      await directory.create(recursive: true);
      final file = File('${directory.path}/a.txt');
      file.writeAsString('asd');
      print('created');
    }
    // final folderName = "ProjectStatistics";
    // final path = Directory("storage/emulated/0/$folderName");
    // if ((await path.exists())) {
    //   print("exist");
    // } else {
    //   print("not exist");
    //   path.create();
    // }
  }
}
