import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class DeleteTaskParams {
  const DeleteTaskParams(this.id);

  final int id;
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  DeleteTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(DeleteTaskParams params) =>
      _repository.deleteTask(params.id);
}
