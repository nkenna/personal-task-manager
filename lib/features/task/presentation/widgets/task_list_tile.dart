import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/core/extensions/string_extension.dart';
import 'package:ptm/features/task/domain/entities/task.dart';

Color taskTitleColor(Task task) => switch (task.status) {
      TaskStatus.pending => Colors.amber,
      TaskStatus.ongoing => Colors.orange,
      TaskStatus.completed => Colors.green,
      TaskStatus.cancelled => Colors.red,
    };

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    this.onTap,
    this.onSelected,
  });

  final Task task;
  final void Function(Task)? onTap;
  final void Function(BuildContext, Task, String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap == null ? null : () => onTap!(task),
      title: Text(
        task.title.capitalizeFirst(),
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: taskTitleColor(task),
        ),
      ),
      subtitle: Text(
        task.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      trailing: onSelected == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) => onSelected!(context, task, value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'update',
                      child: Text('Update Details'),
                    ),
                    PopupMenuItem(
                      value: 'status',
                      child: Text('Change status'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
