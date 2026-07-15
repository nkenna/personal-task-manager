import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/domain/repositories/task_history_repository.dart';

class ListTaskHistoryParams {
  const ListTaskHistoryParams(this.taskId);

  final int taskId;
}

class ListTaskHistory implements UseCase<List<TaskHistory>, ListTaskHistoryParams> {
  ListTaskHistory(this._repository);

  final TaskHistoryRepository _repository;

  @override
  Future<List<TaskHistory>> call(ListTaskHistoryParams params) =>
      _repository.listByTask(params.taskId);
}
