class Plan {
  Plan({
    this.id,
    this.quantity,
    this.amount,
    this.startPeriod,
    this.endPeriod,
    this.prize,
    this.percent,
    this.ratio,
  });

  int id;
  List<int> quantity;
  List<int> amount;
  String startPeriod;
  String endPeriod;
  double prize;
  double percent;
  double ratio;

  @override
  String toString() {
    return "Plan(id: $id, quantity: $quantity, amount: $amount, startPeriod: $startPeriod, endPeriod: $endPeriod, prize: $prize, percent: $percent, ratio: $ratio)";
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
    id = map['id'];
    quantity = map['quantity'];
    amount = map['amount'];
    startPeriod = map['startPeriod'];
    endPeriod = map['endPeriod'];
    prize = map['prize'];
    percent = map['percent'];
    ratio = map['ratio'];
  }

  Plan.fromValues(List<dynamic> values){
    id = values[0];
    quantity = values[1];
    amount = values[2];
    startPeriod = values[3];
    endPeriod = values[4];
    prize = values[5];
    percent = values[6];
    ratio = values[7];
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
