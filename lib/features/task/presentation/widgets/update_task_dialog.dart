import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/usecases/edit_task.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';

Future<void> showUpdateTaskDialog(
  BuildContext context,
  WidgetRef ref,
  Task task,
) async {
  final titleController = TextEditingController(text: task.title);
  final descriptionController = TextEditingController(text: task.description);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Update Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await ref.read(editTaskProvider).call(
                  EditTaskParams(
                    Task(
                      id: task.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      status: task.status,
                      profileId: task.profileId,
                    ),
                  ),
                );
            ref.invalidate(tasksProvider);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
