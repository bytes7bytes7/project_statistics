import 'dart:math';

class Plan {
  Plan({
    this.id,
    this.quantity,
    this.amount,
    this.start,
    this.end,
    this.prize,
    this.percent,
    this.ratio,
  });

  int id;
  List<int> quantity;
  List<int> amount;
  String start;
  String end;
  double prize;
  double percent;
  double ratio;

  @override
  String toString() {
    return "Plan(id: $id, quantity: $quantity, amount: $amount, start: $start, end: $end, prize: $prize, percent: $percent, ratio: $ratio)";
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
    if (start != other.start) {
      return false;
    }
    if (end != other.end) {
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
    start = map['start'];
    end = map['end'];
    prize = map['prize'];
    percent = map['percent'];
    ratio = map['ratio'];
  }

  Plan.fromValues(List<dynamic> values) {
    id = values[0];
    quantity = values[1];
    amount = values[2];
    start = values[3];
    end = values[4];
    prize = values[5];
    percent = values[6];
    ratio = values[7];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'quantity': quantity?.join(';'),
      'amount': amount?.join(';'),
      'start': start,
      'end': end,
      'prize': prize,
      'percent': percent,
      'ratio': ratio,
    };
  }
}
