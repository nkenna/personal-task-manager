import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/core/navigation/app_router.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';
import 'package:ptm/features/task/presentation/widgets/change_status_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/delete_task_dialog.dart';
import 'package:ptm/features/task/presentation/widgets/task_list_tile.dart';
import 'package:ptm/features/task/presentation/widgets/update_task_dialog.dart';

class TaskSearchDelegate extends SearchDelegate<Task?> {
  TaskSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Search tasks by title or description'));
    }
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) =>
          ref.watch(searchResultsProvider(query)).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (results) => results.isEmpty
            ? const Center(child: Text('No results'))
            : ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final task = results[index];
                  return TaskListTile(
                    task: task,
                    onTap: (task) {
                      if (task.id != null) {
                        close(context, null);
                        ref
                            .read(appRouterDelegateProvider)
                            .showTaskDetails(task.id!);
                      }
                    },
                    onSelected: (context, task, value) async {
                      switch (value) {
                        case 'update':
                          await showUpdateTaskDialog(context, ref, task);
                        case 'status':
                          await showChangeStatusDialog(context, ref, task);
                          ref.invalidate(searchResultsProvider(query));
                        case 'delete':
                          final deleted =
                              await showDeleteTaskDialog(context, ref, task);
                          if (deleted) {
                            ref.invalidate(searchResultsProvider(query));
                          }
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
