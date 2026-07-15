import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class ChangeTaskStatusParams {
  const ChangeTaskStatusParams(this.id, this.status);

  final int id;
  final TaskStatus status;
}

class ChangeTaskStatus implements UseCase<void, ChangeTaskStatusParams> {
  ChangeTaskStatus(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(ChangeTaskStatusParams params) =>
      _repository.changeTaskStatus(params.id, params.status);
}
