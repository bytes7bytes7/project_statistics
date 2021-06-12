class Result {
  Result({
    this.amount,
    this.quantity,
    this.plan,
    this.percent,
    this.until,
    this.prize,
  });

  double amount;
  int quantity;
  int plan;
  int percent;
  double until;
  double prize;

  Result.fromMap(Map<String, dynamic> map) {
    amount = map['amount'];
    quantity = map['quantity'];
    plan = map['plan'];
    percent = map['percent'];
    until = map['until'];
    prize = map['prize'];
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'quantity': quantity,
      'plan': plan,
      'percent': percent,
      'until': until,
      'prize': prize,
    };
  }
}
