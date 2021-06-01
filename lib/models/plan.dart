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

  @override
  String toString(){
    return "Plan(quantity: $quantity, amount: $amount, startPeriod: $startPeriod, endPeriod: $endPeriod, prize: $prize)";
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    for (int i = 0; i < quantity.length; i++) {
      print('quantity');
      if (quantity[i] != other.quantity[i]) return false;
    }
    for (int i = 0; i < amount.length; i++) {
      print('amount');
      if (amount[i] != other.amount[i]) return false;
    }
    if (startPeriod != other.startPeriod) {
      print('startPeriod');
      return false;
    }
    if (endPeriod != other.endPeriod) {
      print('endPeriod');
      return false;
    }
    if (prize != other.prize) {
      print('prize');
      return false;
    }
    return true;
  }

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
      'endPeriod': endPeriod,
      'prize': prize,
    };
  }
}
