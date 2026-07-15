import 'package:ptm/core/database/database_helper.dart';
import 'package:ptm/features/task/data/models/task_history_model.dart';

class TaskHistoryLocalDataSource {
  TaskHistoryLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String table = 'task_history';

  Future<int> addHistory(TaskHistoryModel history) async {
    return _databaseHelper.insert(table, history.toMap());
  }

  Future<List<TaskHistoryModel>> listByTask(int taskId) async {
    final rows = await _databaseHelper.query(
      table,
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'date DESC',
    );
    return rows.map(TaskHistoryModel.fromMap).toList();
  }
}
