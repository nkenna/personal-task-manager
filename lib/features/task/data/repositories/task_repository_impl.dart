import 'package:ptm/features/task/data/datasources/local/task_history_local_data_source.dart';
import 'package:ptm/features/task/data/datasources/local/task_local_data_source.dart';
import 'package:ptm/features/task/data/models/task_history_model.dart';
import 'package:ptm/features/task/data/models/task_model.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._localDataSource, this._historyLocalDataSource);

  final TaskLocalDataSource _localDataSource;
  final TaskHistoryLocalDataSource _historyLocalDataSource;

  @override
  Future<int> addTask(Task task) async {
    return _localDataSource.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> editTask(Task task) async {
    await _localDataSource.editTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(int id) async {
    await _localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> listTasks({int? profileId}) async {
    final models = await _localDataSource.listTasks(profileId: profileId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> changeTaskStatus(int id, TaskStatus status) async {
    await _localDataSource.changeTaskStatus(id, status);
    await _historyLocalDataSource.addHistory(
      TaskHistoryModel(
        taskId: id,
        date: DateTime.now(),
        remark: 'Status changed to ${status.name}',
      ),
    );
  }

  @override
  Future<List<Task>> searchTasks(
    String query, {
    int? profileId,
    TaskStatus? status,
  }) async {
    final models = await _localDataSource.searchTasks(
      query,
      profileId: profileId,
      status: status,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
