import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/domain/repositories/task_history_repository.dart';

class AddTaskHistoryParams {
  const AddTaskHistoryParams(this.history);

  final TaskHistory history;
}

class AddTaskHistory implements UseCase<int, AddTaskHistoryParams> {
  AddTaskHistory(this._repository);

  final TaskHistoryRepository _repository;

  @override
  Future<int> call(AddTaskHistoryParams params) =>
      _repository.addHistory(params.history);
}
