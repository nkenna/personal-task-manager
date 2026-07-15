import 'package:ptm/features/task/data/datasources/local/task_history_local_data_source.dart';
import 'package:ptm/features/task/data/models/task_history_model.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/domain/repositories/task_history_repository.dart';

class TaskHistoryRepositoryImpl implements TaskHistoryRepository {
  TaskHistoryRepositoryImpl(this._localDataSource);

  final TaskHistoryLocalDataSource _localDataSource;

  @override
  Future<int> addHistory(TaskHistory history) async {
    return _localDataSource.addHistory(
      TaskHistoryModel.fromEntity(history),
    );
  }

  @override
  Future<List<TaskHistory>> listByTask(int taskId) async {
    final models = await _localDataSource.listByTask(taskId);
    return models.map((model) => model.toEntity()).toList();
  }
}
