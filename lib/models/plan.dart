class Plan {
  Plan({
    this.id,
    this.quantity,
    this.amount,
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.prize,
    this.percent,
    this.ratio,
  });

  int id;
  List<int> quantity;
  List<int> amount;
  String startMonth;
  int startYear;
  String endMonth;
  int endYear;
  double prize;
  double percent;
  double ratio;

  @override
  String toString() {
    return "Plan(id: $id, quantity: $quantity, amount: $amount, startMonth: $startMonth, startYear: $startYear, endMonth: $endMonth, endYear: $endYear, prize: $prize, percent: $percent, ratio: $ratio)";
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (other.runtimeType != Plan) return false;
    for (int i = 0; i < quantity.length; i++) {
      if (quantity[i] != other.quantity[i]) return false;
    }
    for (int i = 0; i < amount.length; i++) {
      if (amount[i] != other.amount[i]) return false;
    }
    if (startMonth != other.startMonth) {
      return false;
    }
    if (startYear != other.startYear) {
      return false;
    }
    if (endMonth != other.endMonth) {
      return false;
    }
    if (endYear != other.endYear) {
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
    startMonth = map['startMonth'];
    startYear = map['startYear'];
    endMonth = map['endMonth'];
    endYear = map['endYear'];
    prize = map['prize'];
    percent = map['percent'];
    ratio = map['ratio'];
  }

  Plan.fromValues(List<dynamic> values) {
    id = values[0];
    quantity = values[1];
    amount = values[2];
    startMonth = values[3];
    startYear = values[4];
    endMonth = values[5];
    endYear = values[6];
    prize = values[7];
    percent = values[8];
    ratio = values[9];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'quantity': quantity?.join(';'),
      'amount': amount?.join(';'),
      'startMonth': startMonth,
      'startYear': startYear,
      'endMonth': endMonth,
      'endYear': endYear,
      'prize': prize,
      'percent': percent,
      'ratio': ratio,
    };
  }
}
