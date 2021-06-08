class Project {
  Project({
    this.id,
    this.title,
    this.status,
    this.price,
    this.startPeriod,
    this.endPeriod,
    this.complete,
  });

  int id;
  String title;
  String status;
  int price;
  String startPeriod;
  String endPeriod;
  String complete;

  @override
  String toString() {
    return 'Project(id: $id, title: $title, status: $status, price: $price, startPeriod: $startPeriod, endPeriod: $endPeriod, complete: $complete)';
  }

  Project.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    status = map['status'];
    price = map['price'];
    startPeriod = map['startPeriod'];
    endPeriod = map['endPeriod'];
    complete = map['complete'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'price': price,
      'startPeriod': startPeriod,
      'endPeriod': endPeriod,
      'complete': complete,
    };
  }
}
