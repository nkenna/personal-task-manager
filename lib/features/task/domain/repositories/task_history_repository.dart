import 'package:ptm/features/task/domain/entities/task_history.dart';

abstract class TaskHistoryRepository {
  Future<int> addHistory(TaskHistory history);

  Future<List<TaskHistory>> listByTask(int taskId);
}
