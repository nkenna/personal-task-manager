import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/presentation/providers/profile_providers.dart';
import 'package:ptm/features/profile/presentation/screens/create_profile_screen.dart';
import 'package:ptm/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:ptm/features/profile/presentation/screens/switch_profile_screen.dart';
import 'package:ptm/features/profile/presentation/screens/update_profile_screen.dart';
import 'package:ptm/features/task/presentation/screens/add_task_page.dart';
import 'package:ptm/features/task/presentation/screens/landing_page.dart';
import 'package:ptm/features/task/presentation/screens/task_details_page.dart';

class AppRoutePath {
  const AppRoutePath._(this.location, {this.taskId});

  factory AppRoutePath.home() => const AppRoutePath._('/');

  factory AppRoutePath.addTask() => const AppRoutePath._('/add-task');

  factory AppRoutePath.taskDetails(int id) =>
      AppRoutePath._('/task/$id', taskId: id);

  factory AppRoutePath.profile() => const AppRoutePath._('/profile');

  factory AppRoutePath.updateProfile() =>
      const AppRoutePath._('/profile/update');

  factory AppRoutePath.switchProfile() =>
      const AppRoutePath._('/profile/switch');

  factory AppRoutePath.createProfile() => const AppRoutePath._('/create');

  final String location;
  final int? taskId;

  bool get isAddTask => location == '/add-task';

  bool get isTaskDetails => taskId != null;

  bool get isProfile => location == '/profile';

  bool get isUpdateProfile => location == '/profile/update';

  bool get isSwitchProfile => location == '/profile/switch';

  bool get isCreate => location == '/create';
}

class AppRouteInformationParser
    extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final segments = routeInformation.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();

    if (segments.isEmpty) return AppRoutePath.home();
    if (segments.first == 'add-task') return AppRoutePath.addTask();
    if (segments.first == 'task' && segments.length == 2) {
      final id = int.tryParse(segments[1]);
      if (id != null) return AppRoutePath.taskDetails(id);
    }
    if (segments.first == 'profile') {
      if (segments.length > 1 && segments[1] == 'update') {
        return AppRoutePath.updateProfile();
      }
      if (segments.length > 1 && segments[1] == 'switch') {
        return AppRoutePath.switchProfile();
      }
      return AppRoutePath.profile();
    }
    if (segments.first == 'create') return AppRoutePath.createProfile();
    return AppRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier {
  AppRouterDelegate(this.ref) {
    ref.listen<AsyncValue<Profile?>>(activeProfileProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath _configuration = AppRoutePath.home();

  void showAddTask() {
    _configuration = AppRoutePath.addTask();
    notifyListeners();
  }

  void showTaskDetails(int id) {
    _configuration = AppRoutePath.taskDetails(id);
    notifyListeners();
  }

  void showProfile() {
    _configuration = AppRoutePath.profile();
    notifyListeners();
  }

  void showUpdateProfile() {
    _configuration = AppRoutePath.updateProfile();
    notifyListeners();
  }

  void showSwitchProfile() {
    _configuration = AppRoutePath.switchProfile();
    notifyListeners();
  }

  void showCreateProfile() {
    _configuration = AppRoutePath.createProfile();
    notifyListeners();
  }

  void backToHome() {
    _configuration = AppRoutePath.home();
    notifyListeners();
  }

  void back() {
    if (_configuration.isUpdateProfile ||
        _configuration.isSwitchProfile ||
        _configuration.isCreate) {
      _configuration = AppRoutePath.profile();
    } else if (_configuration.isAddTask ||
        _configuration.isTaskDetails ||
        _configuration.isProfile) {
      _configuration = AppRoutePath.home();
    }
    notifyListeners();
  }

  @override
  AppRoutePath get currentConfiguration => _configuration;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _configuration = configuration;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.read(activeProfileProvider);
    final profile = profileAsync.value;

    final pages = <Page<void>>[];
    if (profileAsync.isLoading) {
      pages.add(const MaterialPage<void>(child: _LoadingScreen()));
    } else if (profile == null) {
      pages.add(const MaterialPage<void>(child: CreateProfileScreen()));
    } else {
      pages.add(MaterialPage<void>(child: LandingPage(profile: profile)));
      if (_configuration.isAddTask) {
        pages.add(const MaterialPage<void>(child: AddTaskPage()));
      } else if (_configuration.isTaskDetails) {
        pages.add(
          MaterialPage<void>(
            key: ValueKey('task-${_configuration.taskId}'),
            child: TaskDetailsPage(taskId: _configuration.taskId!),
          ),
        );
      } else if (_configuration.isProfile ||
          _configuration.isUpdateProfile ||
          _configuration.isSwitchProfile ||
          _configuration.isCreate) {
        pages.add(const MaterialPage<void>(child: ProfileDetailsScreen()));
        if (_configuration.isUpdateProfile) {
          pages.add(const MaterialPage<void>(child: UpdateProfileScreen()));
        } else if (_configuration.isSwitchProfile) {
          pages.add(const MaterialPage<void>(child: SwitchProfileScreen()));
        } else if (_configuration.isCreate) {
          pages.add(const MaterialPage<void>(child: CreateProfileScreen()));
        }
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        back();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

final appRouteInformationParserProvider =
    Provider<AppRouteInformationParser>((ref) {
  return AppRouteInformationParser();
});

final appRouterDelegateProvider = Provider<AppRouterDelegate>((ref) {
  return AppRouterDelegate(ref);
});
