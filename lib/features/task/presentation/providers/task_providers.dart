import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/core/providers/database_provider.dart';
import 'package:ptm/features/profile/presentation/providers/profile_providers.dart';
import 'package:ptm/features/task/data/datasources/local/task_history_local_data_source.dart';
import 'package:ptm/features/task/data/datasources/local/task_local_data_source.dart';
import 'package:ptm/features/task/data/repositories/task_history_repository_impl.dart';
import 'package:ptm/features/task/data/repositories/task_repository_impl.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/domain/repositories/task_history_repository.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';
import 'package:ptm/features/task/domain/usecases/add_task.dart';
import 'package:ptm/features/task/domain/usecases/add_task_history.dart';
import 'package:ptm/features/task/domain/usecases/change_task_status.dart';
import 'package:ptm/features/task/domain/usecases/delete_task.dart';
import 'package:ptm/features/task/domain/usecases/edit_task.dart';
import 'package:ptm/features/task/domain/usecases/list_task_history.dart';
import 'package:ptm/features/task/domain/usecases/list_tasks.dart';
import 'package:ptm/features/task/domain/usecases/search_tasks.dart';

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource(ref.watch(databaseHelperProvider));
});

final taskHistoryLocalDataSourceProvider =
    Provider<TaskHistoryLocalDataSource>((ref) {
  return TaskHistoryLocalDataSource(ref.watch(databaseHelperProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    ref.watch(taskLocalDataSourceProvider),
    ref.watch(taskHistoryLocalDataSourceProvider),
  );
});

final taskHistoryRepositoryProvider = Provider<TaskHistoryRepository>((ref) {
  return TaskHistoryRepositoryImpl(
    ref.watch(taskHistoryLocalDataSourceProvider),
  );
});

final addTaskProvider = Provider<AddTask>((ref) {
  return AddTask(ref.watch(taskRepositoryProvider));
});

final editTaskProvider = Provider<EditTask>((ref) {
  return EditTask(ref.watch(taskRepositoryProvider));
});

final listTasksProvider = Provider<ListTasks>((ref) {
  return ListTasks(ref.watch(taskRepositoryProvider));
});

final changeTaskStatusProvider = Provider<ChangeTaskStatus>((ref) {
  return ChangeTaskStatus(ref.watch(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.watch(taskRepositoryProvider));
});

final searchTasksProvider = Provider<SearchTasks>((ref) {
  return SearchTasks(ref.watch(taskRepositoryProvider));
});

final addTaskHistoryProvider = Provider<AddTaskHistory>((ref) {
  return AddTaskHistory(ref.watch(taskHistoryRepositoryProvider));
});

final listTaskHistoryProvider = Provider<ListTaskHistory>((ref) {
  return ListTaskHistory(ref.watch(taskHistoryRepositoryProvider));
});

final taskHistoryProvider =
    FutureProvider.family<List<TaskHistory>, int>((ref, taskId) {
  final list = ref.watch(listTaskHistoryProvider);
  return list.call(ListTaskHistoryParams(taskId));
});

final searchResultsProvider =
    FutureProvider.family<List<Task>, String>((ref, query) async {
  final profile = await ref.watch(activeProfileProvider.future);
  if (profile == null || query.trim().isEmpty) return <Task>[];
  final search = ref.watch(searchTasksProvider);
  return search.call(SearchTasksParams(query, profileId: profile.id));
});

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final profile = await ref.watch(activeProfileProvider.future);
  if (profile == null) return <Task>[];
  final listTasks = ref.watch(listTasksProvider);
  return listTasks.call(ListTasksParams(profileId: profile.id));
});
