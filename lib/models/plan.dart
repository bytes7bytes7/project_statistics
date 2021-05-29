import 'package:flutter/material.dart';

class Plan {
  Plan({
    this.quantity,
    this.amount,
    this.period,
    this.prize,
  });

  List<int> quantity;
  List<double> amount;
  String period;
  double prize;

  Plan.fromMap(Map<String, dynamic> map) {
    quantity = map['quantity'];
    amount = map['amount'];
    period = map['period'];
    prize = map['prize'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'quantity': quantity?.join(';'),
      'amount': amount?.join(';'),
      'period': period,
      'prize': prize,
    };
  }
}
