import 'package:ptm/features/task/domain/entities/task_history.dart';

class TaskHistoryModel {
  const TaskHistoryModel({
    this.id,
    required this.taskId,
    required this.date,
    required this.remark,
  });

  final int? id;
  final int taskId;
  final DateTime date;
  final String remark;

  factory TaskHistoryModel.fromMap(Map<String, dynamic> map) {
    return TaskHistoryModel(
      id: map['id'] as int?,
      taskId: map['task_id'] as int,
      date: DateTime.parse(map['date'] as String),
      remark: map['remark'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'task_id': taskId,
      'date': date.toIso8601String(),
      'remark': remark,
    };
  }

  factory TaskHistoryModel.fromEntity(TaskHistory history) {
    return TaskHistoryModel(
      id: history.id,
      taskId: history.taskId,
      date: history.date,
      remark: history.remark,
    );
  }

  TaskHistory toEntity() {
    return TaskHistory(
      id: id,
      taskId: taskId,
      date: date,
      remark: remark,
    );
  }
}
