import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/usecases/delete_task.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';

Future<bool> showDeleteTaskDialog(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true && task.id != null) {
    await ref.read(deleteTaskProvider).call(DeleteTaskParams(task.id!));
    ref.invalidate(tasksProvider);
    return true;
  }
  return false;
}
