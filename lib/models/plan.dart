import '../constants.dart';

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

  static Map<String, dynamic> formatMap(Map<String, dynamic> oldMap){
    List<String> keys = oldMap.keys.toList();
    List<String> values = oldMap.values.map<String>((e) => e.toString()).toList();
    Map<String, dynamic> newMap =Map.fromIterables(keys, values);
    if(newMap['id'].isNotEmpty){
      try {
        newMap['id'] = int.parse(newMap['id']);
      }catch(error){
        return null;
      }
    }else{
      return null;
    }
    if(newMap['quantity'].isNotEmpty){
      try {
        newMap['quantity'] =
            newMap['quantity'].split(';').map<int>((e) => int.parse(e)).toList();
      }catch(error){
        return null;
      }
    }else{
      return null;
    }
    if(newMap['amount'].isNotEmpty){
      try {
        newMap['amount'] =
            newMap['amount'].split(';').map<int>((e) => int.parse(e)).toList();
      }catch(error){
        return null;
      }
    }else{
      return null;
    }
    if(newMap['start'].isNotEmpty){
      newMap['start'] = newMap['start'];
    }else{
      return null;
    }
    if(newMap['end'].isNotEmpty){
      newMap['end'] = newMap['end'];
    }else{
      return null;
    }
    if(newMap['prize'].isNotEmpty){
      newMap['prize'] = double.parse(newMap['prize']);
    }else{
      return null;
    }
    if(newMap['percent'].isNotEmpty){
      newMap['percent'] = double.parse(newMap['percent']);
    }else{
      return null;
    }
    if(newMap['ratio'].isNotEmpty){
      newMap['ratio'] = double.parse(newMap['ratio']);
    }else{
      return null;
    }
    return newMap;
  }

  static List<String> getHeaderRow() {
    return [
      ConstDBData.id,
      ConstDBData.quantity,
      ConstDBData.amount,
      ConstDBData.start,
      ConstDBData.end,
      ConstDBData.prize,
      ConstDBData.percent,
      ConstDBData.ratio,
    ];
  }

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
