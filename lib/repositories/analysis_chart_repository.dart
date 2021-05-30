import '../database/database_helper.dart';
import '../models/analysis_chart.dart';

class AnalysisChartRepository {
  Future<AnalysisChart> getAnalysisChart(String startPeriod, String endPeriod) async {
    return await DatabaseHelper.db.getAnalysisChart(startPeriod,endPeriod);
  }
}
