import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/core/extensions/string_extension.dart';
import 'package:ptm/features/task/domain/entities/task.dart';

Color taskStatusColor(Task task) => switch (task.status) {
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
    final accent = taskStatusColor(task);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withAlpha(12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap == null ? null : () => onTap!(task),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 40,
                margin: const EdgeInsets.only(right: 12, top: 2),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title.capitalizeFirst(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: taskStatusColor(task),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onSelected != null)
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
        ),
      ),
    );
  }
}
