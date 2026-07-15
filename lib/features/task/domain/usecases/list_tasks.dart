import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class ListTasksParams {
  const ListTasksParams({this.profileId});

  final int? profileId;
}

class ListTasks implements UseCase<List<Task>, ListTasksParams> {
  ListTasks(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<Task>> call(ListTasksParams params) =>
      _repository.listTasks(profileId: params.profileId);
}
