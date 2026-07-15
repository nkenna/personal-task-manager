import 'package:ptm/features/task/domain/entities/task.dart';

class TaskModel {
  const TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.profileId,
  });

  final int? id;
  final String title;
  final String description;
  final TaskStatus status;
  final int profileId;

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      status: TaskStatus.values.byName(map['status'] as String),
      profileId: map['profile_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'profile_id': profileId,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      profileId: task.profileId,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: status,
      profileId: profileId,
    );
  }
}
