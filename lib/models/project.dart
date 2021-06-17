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

  static List<String> getHeaderRow(){
    return [
      ConstDBData.id,
      ConstDBData.title,
      ConstDBData.status,
      ConstDBData.price,
      ConstDBData.date,
      ConstDBData.complete,
    ];
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
