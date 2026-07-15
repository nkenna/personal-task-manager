import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';

class SearchTasksParams {
  const SearchTasksParams(
    this.query, {
    this.profileId,
    this.status,
  });

  final String query;
  final int? profileId;
  final TaskStatus? status;
}

class SearchTasks implements UseCase<List<Task>, SearchTasksParams> {
  SearchTasks(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<Task>> call(SearchTasksParams params) =>
      _repository.searchTasks(
        params.query,
        profileId: params.profileId,
        status: params.status,
      );
}
