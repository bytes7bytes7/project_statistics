class Plan {
  Plan({
    this.quantity,
    this.amount,
    this.startPeriod,
    this.endPeriod,
    this.prize,
    this.percent,
    this.ratio,
  });

  List<int> quantity;
  List<double> amount;
  String startPeriod;
  String endPeriod;
  double prize;
  double percent;
  double ratio;

  @override
  String toString() {
    return "Plan(quantity: $quantity, amount: $amount, startPeriod: $startPeriod, endPeriod: $endPeriod, prize: $prize, percent: $percent, ratio: $ratio)";
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    for (int i = 0; i < quantity.length; i++) {
      if (quantity[i] != other.quantity[i]) return false;
    }
    for (int i = 0; i < amount.length; i++) {
      if (amount[i] != other.amount[i]) return false;
    }
    if (startPeriod != other.startPeriod) {
      return false;
    }
    if (endPeriod != other.endPeriod) {
      return false;
    }
    if (prize != other.prize) {
      return false;
    }
    if (percent != other.percent) {
      return false;
    }
    if (ratio != other.ratio) {
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
    percent = map['percent'];
    ratio = map['ratio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'quantity': quantity?.join(';'),
      'amount': amount?.join(';'),
      'startPeriod': startPeriod,
      'endPeriod': endPeriod,
      'prize': prize,
      'percent': percent,
      'ratio': ratio,
    };
  }
}
