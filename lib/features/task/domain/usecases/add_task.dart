import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class AddTaskParams {
  const AddTaskParams(this.task);

  final Task task;
}

class AddTask implements UseCase<int, AddTaskParams> {
  AddTask(this._repository);

  final TaskRepository _repository;

  @override
  Future<int> call(AddTaskParams params) => _repository.addTask(params.task);
}
