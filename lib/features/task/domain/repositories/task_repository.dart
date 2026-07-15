import 'package:ptm/features/task/domain/entities/task.dart';

abstract class TaskRepository {
  Future<int> addTask(Task task);

  Future<void> editTask(Task task);

  Future<void> deleteTask(int id);

  Future<List<Task>> listTasks({int? profileId});

  Future<void> changeTaskStatus(int id, TaskStatus status);

  Future<List<Task>> searchTasks(
    String query, {
    int? profileId,
    TaskStatus? status,
  });
}
