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

  static Map<String, dynamic> formatMap(Map<String, dynamic> oldMap) {
    List<String> keys = oldMap.keys.toList();
    List<String> values =
        oldMap.values.map<String>((e) => e.toString()).toList();
    Map<String, dynamic> newMap = Map.fromIterables(keys, values);
    if (newMap['id'] != 'null') {
      try {
        newMap['id'] = int.parse(newMap['id'].replaceAll(' ', ''));
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['quantity'] != 'null') {
      try {
        newMap['quantity'] = newMap['quantity']
            .split(';')
            .map<int>((e) => int.parse(e.replaceAll(' ', '')))
            .toList();
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['amount'] != 'null') {
      try {
        newMap['amount'] = newMap['amount']
            .split(';')
            .map<int>((e) => int.parse(e.replaceAll(' ', '')))
            .toList();
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['startMonth'] == 'null') {
      return null;
    }
    if (newMap['startYear'] != 'null') {
      try {
        newMap['startYear'] = int.parse(newMap['startYear'].replaceAll(' ',''));
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['endMonth'] == 'null') {
      return null;
    }
    if (newMap['endYear'] != 'null') {
      try {
        newMap['endYear'] = int.parse(newMap['endYear'].replaceAll(' ',''));
      } catch (error) {
        return null;
      }
    } else {
      return null;
    }
    if (newMap['prize'] != 'null') {
      newMap['prize'] = double.parse(newMap['prize'].replaceAll(' ',''));
    } else {
      return null;
    }
    if (newMap['percent'] != 'null') {
      newMap['percent'] = double.parse(newMap['percent'].replaceAll(' ',''));
    } else {
      return null;
    }
    if (newMap['ratio'] != 'null') {
      newMap['ratio'] = double.parse(newMap['ratio'].replaceAll(' ',''));
    } else {
      return null;
    }
    return Map<String, dynamic>.from(newMap);
  }

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
