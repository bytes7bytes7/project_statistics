class Project {
  Project({
    this.id,
    this.title,
    this.status,
    this.price,
    this.startPeriod,
    this.endPeriod,
  });

  int id;
  String title;
  String status;
  int price;
  String startPeriod;
  String endPeriod;

  Project.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    status = map['status'];
    price = map['price'];
    startPeriod = map['startPeriod'];
    endPeriod = map['endPeriod'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'price': price,
      'startPeriod': startPeriod,
      'endPeriod': endPeriod,
    };
  }
}
