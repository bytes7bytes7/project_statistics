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
  String year;
  String complete;

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
