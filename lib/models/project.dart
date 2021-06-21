import '../constants.dart';

class Project {
  Project({
    this.id,
    this.title,
    this.status,
    this.price,
    this.month,
    this.year,
    this.complete,
  });

  int id;
  String title;
  String status;
  int price;
  String month;
  int year;
  String complete;

  static Map<String, dynamic> formatMap(Map<String, dynamic> oldMap) {
    List<String> keys = oldMap.keys.toList();
    List<String> values =
        oldMap.values.map<String>((e) => e.toString()).toList();
    Map<String, dynamic> newMap = Map.fromIterables(keys, values);
    if (newMap['id']!= 'null') {
      try {
        newMap['id'] = int.parse(newMap['id']);
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['title'] == 'null') {
      return null;
    }
    if (newMap['status'] == 'null') {
      return null;
    }
    if (newMap['price']!= 'null') {
      try {
        newMap['price'] = int.parse(newMap['price']);
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['month']== 'null') {
      return null;
    }
    if (newMap['year'] != 'null') {
      try {
        newMap['year'] = int.parse(newMap['year']);
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['complete'] == 'null') {
      return null;
    }

    return newMap;
  }

  // To export
  static List<String> getHeaderRow() {
    return [
      ConstDBData.id.ru,
      ConstDBData.title.ru,
      ConstDBData.status.ru,
      ConstDBData.price.ru,
      ConstDBData.month.ru,
      ConstDBData.year.ru,
      ConstDBData.complete.ru,
    ];
  }

  static List<String> translateToEN(List<String> list) {
    Map<int, String> indexed = {};
    if(list.contains(ConstDBData.id.ru)){
      indexed[list.indexOf(ConstDBData.id.ru)] = ConstDBData.id.en;
    }
    if(list.contains(ConstDBData.title.ru)){
      indexed[list.indexOf(ConstDBData.title.ru)] = ConstDBData.title.en;
    }
    if(list.contains(ConstDBData.status.ru)){
      indexed[list.indexOf(ConstDBData.status.ru)] = ConstDBData.status.en;
    }
    if(list.contains(ConstDBData.price.ru)){
      indexed[list.indexOf(ConstDBData.price.ru)] = ConstDBData.price.en;
    }
    if(list.contains(ConstDBData.month.ru)){
      indexed[list.indexOf(ConstDBData.month.ru)] = ConstDBData.month.en;
    }
    if(list.contains(ConstDBData.year.ru)){
      indexed[list.indexOf(ConstDBData.year.ru)] = ConstDBData.year.en;
    }
    if(list.contains(ConstDBData.complete.ru)){
      indexed[list.indexOf(ConstDBData.complete.ru)] = ConstDBData.complete.en;
    }
    List<int> keys = indexed.keys.toList();
    keys.sort();
    return keys.map<String>((k) => indexed[k]).toList();
  }

  @override
  String toString() {
    return 'Project(id: $id, title: $title, status: $status, price: $price, month: $month, year: $year, complete: $complete)';
  }

  Project.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    status = map['status'];
    price = map['price'];
    month = map['month'];
    year = map['year'];
    complete = map['complete'];
  }

  Project.fromValues(List<dynamic> values) {
    id = values[0];
    title = values[1];
    status = values[2];
    price = values[3];
    month = values[4];
    year = values[5];
    complete = values[6];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'price': price,
      'month': month,
      'year': year,
      'complete': complete,
    };
  }
}
