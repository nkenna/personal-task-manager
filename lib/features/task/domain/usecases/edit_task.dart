import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class EditTaskParams {
  const EditTaskParams(this.task);

  final Task task;
}

class EditTask implements UseCase<void, EditTaskParams> {
  EditTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> call(EditTaskParams params) => _repository.editTask(params.task);
}
