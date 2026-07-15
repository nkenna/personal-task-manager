import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/usecases/change_task_status.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';

const Map<TaskStatus, ({String label, String description, IconData icon, Color color})>
    _statusMeta = {
  TaskStatus.pending: (
    label: 'Pending',
    description: 'Not started yet',
    icon: Icons.schedule,
    color: Colors.amber,
  ),
  TaskStatus.ongoing: (
    label: 'Ongoing',
    description: 'Work in progress',
    icon: Icons.trending_up,
    color: Colors.orange,
  ),
  TaskStatus.completed: (
    label: 'Completed',
    description: 'Marked as done',
    icon: Icons.check_circle,
    color: Colors.green,
  ),
  TaskStatus.cancelled: (
    label: 'Cancelled',
    description: 'No longer needed',
    icon: Icons.cancel,
    color: Colors.red,
  ),
};

Future<void> showChangeStatusDialog(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final status = await showDialog<TaskStatus>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update status'),
          const SizedBox(height: 4),
          Text(
            'Current: ${_statusMeta[task.status]!.label}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _statusMeta[task.status]!.color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: TaskStatus.values.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final status = TaskStatus.values[index];
            final meta = _statusMeta[status]!;
            final isCurrent = status == task.status;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.of(dialogContext).pop(status),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: meta.color.withAlpha(38),
                      child: Icon(meta.icon, color: meta.color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meta.label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            meta.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Icon(Icons.check_circle, color: meta.color)
                    else
                      const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );

  if (status != null && task.id != null) {
    await ref.read(changeTaskStatusProvider).call(
          ChangeTaskStatusParams(task.id!, status),
        );
    ref.invalidate(tasksProvider);
  }
}
