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

  copy(AnalysisChart other){
    realQuantity = [];
    planQuantity = [];
    realAmount = [];
    planAmount = [];
    for(var e in other.realQuantity){
      realQuantity.add(e);
    }
    for(var e in other.planQuantity){
      planQuantity.add(e);
    }
    for(var e in other.realAmount){
      realAmount.add(e);
    }
    for(var e in other.planAmount){
      planAmount.add(e);
    }
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
