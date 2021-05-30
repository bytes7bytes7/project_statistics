class Plan {
  Plan({
    this.quantity,
    this.amount,
    this.startPeriod,
    this.endPeriod,
    this.prize,
  });

  List<int> quantity;
  List<double> amount;
  String startPeriod;
  String endPeriod;
  double prize;

  Plan.fromMap(Map<String, dynamic> map) {
    quantity = map['quantity'];
    amount = map['amount'];
    startPeriod = map['startPeriod'];
    endPeriod = map['endPeriod'];
    prize = map['prize'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'quantity': quantity?.join(';'),
      'amount': amount?.join(';'),
      'startPeriod': startPeriod,
      'endPeriod':endPeriod,
      'prize': prize,
    };
  }
}
