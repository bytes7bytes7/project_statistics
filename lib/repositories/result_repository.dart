import '../database/database_helper.dart';
import '../models/result.dart';

class ResultRepository {
  Future<Result> getResult(String startPeriod, String endPeriod) async {
    return await DatabaseHelper.db.getResult(startPeriod,endPeriod);
  }
}
