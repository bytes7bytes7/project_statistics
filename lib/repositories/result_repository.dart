import '../database/database_helper.dart';
import '../models/result.dart';

class ResultRepository {
  Future<Result> getResult() async {
    return await DatabaseHelper.db.getResult();
  }
}
