class TaskHistory {
  const TaskHistory({
    this.id,
    required this.taskId,
    required this.date,
    required this.remark,
  });

  final int? id;
  final int taskId;
  final DateTime date;
  final String remark;
}
