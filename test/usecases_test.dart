import 'package:flutter_test/flutter_test.dart';
import 'package:ptm/core/extensions/string_extension.dart';
import 'package:ptm/core/usecase/use_case.dart';
import 'package:ptm/features/profile/data/models/profile_model.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/repositories/profile_repository.dart';
import 'package:ptm/features/profile/domain/usecases/add_profile.dart';
import 'package:ptm/features/profile/domain/usecases/delete_profile.dart';
import 'package:ptm/features/profile/domain/usecases/get_active_profile.dart';
import 'package:ptm/features/profile/domain/usecases/list_profiles.dart';
import 'package:ptm/features/profile/domain/usecases/set_active_profile.dart';
import 'package:ptm/features/profile/domain/usecases/update_profile.dart';
import 'package:ptm/features/task/data/models/task_history_model.dart';
import 'package:ptm/features/task/data/models/task_model.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';
import 'package:ptm/features/task/domain/repositories/task_repository.dart';
import 'package:ptm/features/task/domain/usecases/add_task.dart';
import 'package:ptm/features/task/domain/usecases/change_task_status.dart';
import 'package:ptm/features/task/domain/usecases/delete_task.dart';
import 'package:ptm/features/task/domain/usecases/edit_task.dart';
import 'package:ptm/features/task/domain/usecases/list_tasks.dart';
import 'package:ptm/features/task/domain/usecases/search_tasks.dart';

class FakeProfileRepository implements ProfileRepository {
  final List<Profile> _profiles = [];
  Profile? _active;

  @override
  Future<int> addProfile(Profile profile) async {
    final id = _profiles.isEmpty ? 1 : _profiles.last.id + 1;
    _profiles.add(Profile(id: id, name: profile.name, email: profile.email, isActive: profile.isActive));
    return id;
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = Profile(id: profile.id, name: profile.name, email: profile.email, isActive: profile.isActive);
    }
  }

  @override
  Future<void> deleteProfile(int id) async {
    _profiles.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Profile>> listProfiles() async => List.unmodifiable(_profiles);

  @override
  Future<Profile?> getActiveProfile() async => _active;

  @override
  Future<void> setActiveProfile(int id) async {
    for (var i = 0; i < _profiles.length; i++) {
      _profiles[i] = Profile(id: _profiles[i].id, name: _profiles[i].name, email: _profiles[i].email, isActive: _profiles[i].id == id);
    }
    _active = _profiles.firstWhere((p) => p.id == id, orElse: () => _profiles.first);
  }
}

class FakeTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  final List<TaskHistory> _history = [];

  @override
  Future<int> addTask(Task task) async {
    final id = _tasks.isEmpty ? 1 : _tasks.last.id! + 1;
    _tasks.add(Task(id: id, title: task.title, description: task.description, status: task.status, profileId: task.profileId));
    return id;
  }

  @override
  Future<void> editTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((t) => t.id == id);
    _history.removeWhere((h) => h.taskId == id);
  }

  @override
  Future<List<Task>> listTasks({int? profileId}) async {
    final result = _tasks.where((t) => t.profileId == profileId).toList();
    return List.unmodifiable(result);
  }

  @override
  Future<void> changeTaskStatus(int id, TaskStatus status) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      _tasks[index] = Task(id: _tasks[index].id, title: _tasks[index].title, description: _tasks[index].description, status: status, profileId: _tasks[index].profileId);
    }
  }

  @override
  Future<List<Task>> searchTasks(String query, {int? profileId, TaskStatus? status}) async {
    final lower = query.toLowerCase();
    final result = _tasks.where((t) {
      final matchesProfile = profileId == null || t.profileId == profileId;
      final matchesStatus = status == null || t.status == status;
      final matchesQuery = t.title.toLowerCase().contains(lower) || t.description.toLowerCase().contains(lower);
      return matchesProfile && matchesStatus && matchesQuery;
    }).toList();
    return List.unmodifiable(result);
  }
}

void main() {
  group('StringExtension', () {
    test('capitalizeFirst returns empty for empty string', () {
      expect(''.capitalizeFirst(), '');
    });

    test('capitalizeFirst upper cases first character', () {
      expect('buy milk'.capitalizeFirst(), 'Buy milk');
      expect('task manager'.capitalizeFirst(), 'Task manager');
    });

    test('capitalizeFirst does not change already capitalized', () {
      expect('Buy Milk'.capitalizeFirst(), 'Buy Milk');
    });
  });

  group('Profile usecases (fake repo)', () {
    late FakeProfileRepository fakeRepo;
    late AddProfile addProfile;
    late UpdateProfile updateProfile;
    late DeleteProfile deleteProfile;
    late ListProfiles listProfiles;
    late GetActiveProfile getActiveProfile;
    late SetActiveProfile setActiveProfile;

    setUp(() {
      fakeRepo = FakeProfileRepository();
      addProfile = AddProfile(fakeRepo);
      updateProfile = UpdateProfile(fakeRepo);
      deleteProfile = DeleteProfile(fakeRepo);
      listProfiles = ListProfiles(fakeRepo);
      getActiveProfile = GetActiveProfile(fakeRepo);
      setActiveProfile = SetActiveProfile(fakeRepo);
    });

    test('addProfile assigns id and returns it', () async {
      final id = await addProfile.call(AddProfileParams(Profile(id: 0, name: 'A', email: 'a@b.com', isActive: true)));
      expect(id, 1);
      final list = await listProfiles.call(const NoParams());
      expect(list.length, 1);
      expect(list.first.name, 'A');
    });

    test('setActiveProfile updates active flag', () async {
      final id1 = await addProfile.call(AddProfileParams(Profile(id: 0, name: 'A', email: 'a@b.com', isActive: false)));
      final id2 = await addProfile.call(AddProfileParams(Profile(id: 0, name: 'B', email: 'b@c.com', isActive: false)));
      await setActiveProfile.call(SetActiveProfileParams(id2));
      final active = await getActiveProfile.call(const NoParams());
      expect(active?.id, id2);
      expect(active?.name, 'B');
    });

    test('updateProfile changes fields', () async {
      final id = await addProfile.call(AddProfileParams(Profile(id: 0, name: 'A', email: 'a@b.com', isActive: true)));
      await updateProfile.call(UpdateProfileParams(Profile(id: id, name: 'A Updated', email: 'a@b.com', isActive: true)));
      final list = await listProfiles.call(const NoParams());
      expect(list.first.name, 'A Updated');
    });

    test('deleteProfile removes from list', () async {
      final id = await addProfile.call(AddProfileParams(Profile(id: 0, name: 'A', email: 'a@b.com', isActive: true)));
      await deleteProfile.call(DeleteProfileParams(id));
      final list = await listProfiles.call(const NoParams());
      expect(list, isEmpty);
    });
  });

  group('Task usecases (fake repo)', () {
    late FakeTaskRepository fakeRepo;
    late AddTask addTask;
    late EditTask editTask;
    late DeleteTask deleteTask;
    late ListTasks listTasks;
    late ChangeTaskStatus changeTaskStatus;
    late SearchTasks searchTasks;

    setUp(() {
      fakeRepo = FakeTaskRepository();
      addTask = AddTask(fakeRepo);
      editTask = EditTask(fakeRepo);
      deleteTask = DeleteTask(fakeRepo);
      listTasks = ListTasks(fakeRepo);
      changeTaskStatus = ChangeTaskStatus(fakeRepo);
      searchTasks = SearchTasks(fakeRepo);
    });

    test('addTask assigns id and links to profile', () async {
      final id = await addTask.call(AddTaskParams(Task(id: null, title: 'Buy milk', description: '2 liters', status: TaskStatus.pending, profileId: 1)));
      expect(id, 1);
      final list = await listTasks.call(ListTasksParams(profileId: 1));
      expect(list.length, 1);
      expect(list.first.title, 'Buy milk');
    });

    test('changeTaskStatus updates task', () async {
      final id = await addTask.call(AddTaskParams(Task(id: null, title: 'Task', description: 'Desc', status: TaskStatus.pending, profileId: 1)));
      await changeTaskStatus.call(ChangeTaskStatusParams(id, TaskStatus.completed));
      final list = await listTasks.call(ListTasksParams(profileId: 1));
      expect(list.first.status, TaskStatus.completed);
    });

    test('searchTasks matches title and description', () async {
      await addTask.call(AddTaskParams(Task(id: null, title: 'Buy milk', description: '2 liters', status: TaskStatus.pending, profileId: 1)));
      await addTask.call(AddTaskParams(Task(id: null, title: 'Write code', description: 'Flutter app', status: TaskStatus.ongoing, profileId: 1)));
      final results = await searchTasks.call(SearchTasksParams('milk', profileId: 1));
      expect(results.length, 1);
      expect(results.first.title, 'Buy milk');
    });

    test('deleteTask removes task and history', () async {
      final id = await addTask.call(AddTaskParams(Task(id: null, title: 'Task', description: 'Desc', status: TaskStatus.pending, profileId: 1)));
      await deleteTask.call(DeleteTaskParams(id));
      final list = await listTasks.call(ListTasksParams(profileId: 1));
      expect(list, isEmpty);
    });
  });
}
