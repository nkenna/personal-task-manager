import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/core/navigation/app_router.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';
import 'package:ptm/features/task/presentation/search/task_search_delegate.dart';
import 'package:ptm/features/task/presentation/widgets/change_status_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/delete_task_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/task_list_tile.dart';
import 'package:ptm/features/task/presentation/widgets/update_task_dialog.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key, required this.profile});

  final Profile profile;

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static const List<_TaskTab> _tabs = [
    _TaskTab(label: 'All', status: null),
    _TaskTab(label: 'Pending', status: TaskStatus.pending),
    _TaskTab(label: 'Ongoing', status: TaskStatus.ongoing),
    _TaskTab(label: 'Completed', status: TaskStatus.completed),
    _TaskTab(label: 'Cancelled', status: TaskStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          title: Text(
            "Tasks",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch<Task?>(
                  context: context,
                  delegate: TaskSearchDelegate(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () =>
                    ref.read(appRouterDelegateProvider).showProfile(),
                child: CircleAvatar(
                  child: Text(_initials(profile.name)),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: _tabs.map((tab) => Tab(text: tab.label)).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabs
              .map(
                (tab) => Container(
                  color: const Color(0xFFF5F5F7),
                  child: _TaskList(
                    status: tab.status,
                    onTap: (task) {
                      if (task.id != null) {
                        ref
                            .read(appRouterDelegateProvider)
                            .showTaskDetails(task.id!);
                      }
                    },
                    onSelected: (context, task, value) =>
                        _onMenuItemSelected(context, ref, task, value),
                  ),
                ),
              )
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => ref.read(appRouterDelegateProvider).showAddTask(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _onMenuItemSelected(
    BuildContext context,
    WidgetRef ref,
    Task task,
    String value,
  ) async {
    switch (value) {
      case 'update':
        await showUpdateTaskDialog(context, ref, task);
      case 'status':
        await showChangeStatusDialog(context, ref, task);
      case 'delete':
        await showDeleteTaskDialog(context, ref, task);
    }
  }
}

class _TaskTab {
  const _TaskTab({required this.label, required this.status});

  final String label;
  final TaskStatus? status;
}

class _TaskList extends ConsumerWidget {
  const _TaskList({
    required this.status,
    required this.onTap,
    required this.onSelected,
  });

  final TaskStatus? status;
  final void Function(Task) onTap;
  final void Function(BuildContext, Task, String) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return tasks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (list) {
        final filtered = status == null
            ? list
            : list.where((task) => task.status == status).toList();
            

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No tasks found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to create your first task',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final task = filtered[index];
            return TaskListTile(
              task: task,
              onTap: onTap,
              onSelected: onSelected,
            );
          },
        );
      },
    );
  }
}
