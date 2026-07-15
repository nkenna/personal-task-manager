import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';
import 'package:ptm/features/task/presentation/widgets/change_status_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/delete_task_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/update_task_dialog.dart';

const Map<TaskStatus, ({String label, IconData icon, Color color})> _statusMeta =
    {
  TaskStatus.pending: (
    label: 'Pending',
    icon: Icons.schedule,
    color: Colors.amber,
  ),
  TaskStatus.ongoing: (
    label: 'Ongoing',
    icon: Icons.trending_up,
    color: Colors.orange,
  ),
  TaskStatus.completed: (
    label: 'Completed',
    icon: Icons.check_circle,
    color: Colors.green,
  ),
  TaskStatus.cancelled: (
    label: 'Cancelled',
    icon: Icons.cancel,
    color: Colors.red,
  ),
};

class TaskDetailsPage extends ConsumerWidget {
  const TaskDetailsPage({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return tasks.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (list) {
        final task = list.where((t) => t.id == taskId).firstOrNull;
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task')),
            body: const Center(child: Text('Task not found')),
          );
        }
        return _TaskDetailsView(task: task);
      },
    );
  }
}

class _TaskDetailsView extends ConsumerWidget {
  const _TaskDetailsView({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(taskHistoryProvider(task.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title,  style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _onSelected(context, ref, value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'status', child: Text('Change status')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
        
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            task.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final meta = _statusMeta[task.status]!;
              return Chip(
                avatar: Icon(meta.icon, size: 16, color: meta.color),
                label: Text(
                  meta.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: meta.color,
                  ),
                ),
                backgroundColor: meta.color.withAlpha(30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: meta.color.withAlpha(70)),
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'History',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          history.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
            data: (records) => records.isEmpty
                ? Text('No history yet',  style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, index) =>
                        _HistoryTile(record: records[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    switch (value) {
      case 'edit':
        await showUpdateTaskDialog(context, ref, task);
      case 'status':
        await showChangeStatusDialog(context, ref, task);
        ref.invalidate(taskHistoryProvider(task.id!));
      case 'delete':
        final deleted = await showDeleteTaskDialog(context, ref, task);
        if (deleted && context.mounted) Navigator.of(context).pop();
    }
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});

  final TaskHistory record;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(record.remark, style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),),
      subtitle: Text(
        '${record.date.toLocal()}'.replaceFirst(RegExp(r':\d\d\.\d+$'), ''),
         style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          
      ),
    );
  }
}
