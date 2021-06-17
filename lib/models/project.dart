import '../constants.dart';

class Project {
  Project({
    this.id,
    this.title,
    this.status,
    this.price,
    this.date,
    this.complete,
  });

  int id;
  String title;
  String status;
  int price;
  String date;
  String complete;

  static Map<String, dynamic> formatMap(Map<String, dynamic> oldMap) {
    List<String> keys = oldMap.keys.toList();
    List<String> values =
        oldMap.values.map<String>((e) => e.toString()).toList();
    Map<String, dynamic> newMap = Map.fromIterables(keys, values);
    if (newMap['id'].isNotEmpty) {
      try {
        newMap['id'] = int.parse(newMap['id']);
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['title'].isEmpty) {
      return null;
    }
    if (newMap['status'].isEmpty) {
      return null;
    }
    if (newMap['price'].isNotEmpty) {
      try {
        newMap['price'] = int.parse(newMap['price']);
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['date'].isEmpty) {
      return null;
    }
    if (newMap['complete'].isEmpty) {
      return null;
    }

    return newMap;
  }

  static List<String> getHeaderRow() {
    return [
      ConstDBData.id,
      ConstDBData.title,
      ConstDBData.status,
      ConstDBData.price,
      ConstDBData.date,
      ConstDBData.complete,
    ];
  }

  static List<String> translate(List<String> lst) {
    if (ConstDBData.locale == 'en') {
      ConstDBData.locale = 'ru';
      List<String> result = getHeaderRow();
      ConstDBData.locale = 'en';
      return result;
    } else {
      ConstDBData.locale = 'en';
      List<String> result = getHeaderRow();
      ConstDBData.locale = 'ru';
      return result;
    }
  }

  @override
  String toString() {
    return 'Project(id: $id, title: $title, status: $status, price: $price, date: $date, complete: $complete)';
  }

  Project.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    status = map['status'];
    price = map['price'];
    date = map['date'];
    complete = map['complete'];
  }

  Project.fromValues(List<dynamic> values) {
    id = values[0];
    title = values[1];
    status = values[2];
    price = values[3];
    date = values[4];
    complete = values[5];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'price': price,
      'date': date,
      'complete': complete,
    };
  }
}
