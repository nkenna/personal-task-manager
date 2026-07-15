import 'package:ptm/core/database/database_helper.dart';
import 'package:ptm/features/task/data/models/task_model.dart';
import 'package:ptm/features/task/domain/entities/task.dart';

class TaskLocalDataSource {
  TaskLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String table = 'tasks';

  Future<int> addTask(TaskModel task) async {
    return _databaseHelper.insert(table, task.toMap());
  }

  Future<void> editTask(TaskModel task) async {
    await _databaseHelper.update(
      table,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    await _databaseHelper.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaskModel>> listTasks({int? profileId}) async {
    final rows = await _databaseHelper.query(
      table,
      where: profileId != null ? 'profile_id = ?' : null,
      whereArgs: profileId != null ? [profileId] : null,
      orderBy: 'id DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<void> changeTaskStatus(int id, TaskStatus status) async {
    await _databaseHelper.update(
      table,
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaskModel>> searchTasks(
    String query, {
    int? profileId,
    TaskStatus? status,
  }) async {
    final whereParts = [
      '(title LIKE ? OR description LIKE ?)',
    ];
    final List<Object?> whereArgs = ['%$query%', '%$query%'];

    if (profileId != null) {
      whereParts.add('profile_id = ?');
      whereArgs.add(profileId);
    }
    if (status != null) {
      whereParts.add('status = ?');
      whereArgs.add(status.name);
    }

    final rows = await _databaseHelper.query(
      table,
      where: whereParts.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'id DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }
}
