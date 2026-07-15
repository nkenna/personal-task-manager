enum TaskStatus { pending, ongoing, cancelled, completed }

class Task {
  const Task({
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
}
