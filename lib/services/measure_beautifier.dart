enum MeasureLevel {
  unit,
  thousands,
  millions,
}

class MeasureBeautifier {
  MeasureBeautifier([this.level]);

  MeasureLevel level;

  @override
  String toString() {
    if (level == MeasureLevel.unit) return '';
    if (level == MeasureLevel.thousands) return 'тыс.\n';
    if (level == MeasureLevel.millions) return 'млн.\n';
    return '-';
  }

  String truncateZero(String str) {
    if (str.contains('.')) {
      if (double.parse(str) == double.parse(str).round())
        str = str.substring(0, str.indexOf('.'));
    }
    return str;
  }

  List<String> formatNumber({
    dynamic number,
    MeasureLevel level,
    String measure,
  }) {
    bool negative = number < 0;
    String result = number.abs().toString();
    number = number.abs();
    MeasureBeautifier resultMeasure = MeasureBeautifier(level);
    if (number is int || number is double) {
      if (number >= 1000000 && level == MeasureLevel.unit) {
        result = (number / 1000000).toString();
        resultMeasure.level = MeasureLevel.millions;
      } else if (number >= 1000) {
        if (level == MeasureLevel.unit) {
          result = (number / 1000).toString();
          resultMeasure.level = MeasureLevel.thousands;
        } else if (level == MeasureLevel.thousands) {
          result = (number / 1000).toString();
          resultMeasure.level = MeasureLevel.millions;
        }
      }
    }
    result = truncateZero(result);
    if (negative) {
      result = '-' + result;
    }
    return [result, resultMeasure.toString() + measure];
  }
}
