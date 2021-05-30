class AnalysisChart {
  AnalysisChart({
    this.realQuantity,
    this.planQuantity,
    this.realAmount,
    this.planAmount,
  });

  List<int> realQuantity;
  List<int> planQuantity;
  List<double> realAmount;
  List<double> planAmount;

  AnalysisChart.fromMap(Map<String, dynamic> map) {
    realQuantity = map['realQuantity'];
    planQuantity = map['planQuantity'];
    realAmount = map['realAmount'];
    planAmount = map['planAmount'];
  }

  Map<String, dynamic> toMap() {
    return {
      'realQuantity': realQuantity,
      'planQuantity': planQuantity,
      'realAmount': realAmount,
      'planAmount': planAmount,
    };
  }
}
