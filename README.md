# Personal Task Manager (PTM)

Personal Task Manager is a cross-platform Flutter app for organizing tasks under multiple profiles. Each profile gets its own task space, with full status tracking and history. The app supports profile switching, task CRUD, status changes with history, and search — all built with clean architecture and Riverpod state management.

## Technologies Used

- **Flutter** — cross-platform UI framework
- **Dart** — application language
- **sqflite** — local SQLite persistence
- **flutter_riverpod** — reactive state management and dependency injection
- **Google Fonts** — consistent typography
- **Navigator 2.0 (Router API)** — declarative routing

## Architecture

The project follows **Clean Architecture** with a strict inward dependency rule. Each feature is self-contained and split into four layers:

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart          # Generic sqflite singleton
│   ├── extensions/
│   │   └── string_extension.dart         # String helpers
│   ├── navigation/
│   │   └── app_router.dart               # Navigator 2.0 RouterDelegate + RouteInformationParser
│   ├── providers/
│   │   └── database_provider.dart        # Riverpod provider for DatabaseHelper
│   └── usecase/
│       └── use_case.dart                 # Base UseCase<T, Params> + NoParams
├── features/
│   ├── task/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── task.dart
│   │   │   │   └── task_history.dart
│   │   │   ├── repositories/
│   │   │   │   └── task_repository.dart
│   │   │   └── usecases/                 # add_task, edit_task, delete_task, list_tasks, change_task_status, search_tasks, add_task_history, list_task_history
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── task_model.dart
│   │   │   │   └── task_history_model.dart
│   │   │   ├── datasources/local/
│   │   │   │   ├── task_local_data_source.dart
│   │   │   │   └── task_history_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── task_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── task_providers.dart
│   │       ├── screens/
│   │       │   ├── landing_page.dart
│   │       │   ├── add_task_page.dart
│   │       │   └── task_details_page.dart
│   │       ├── search/
│   │       │   └── task_search_delegate.dart
│   │       └── widgets/
│   │           ├── task_list_tile.dart
│   │           ├── update_task_dialog.dart
│   │           ├── change_status_dialog.dart
│   │           └── delete_task_dialog.dart
│   └── profile/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── profile.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── usecases/                 # add_profile, update_profile, delete_profile, list_profiles, get_active_profile, set_active_profile
│       ├── data/
│       │   ├── models/
│       │   │   └── profile_model.dart
│       │   ├── datasources/local/
│       │   │   └── profile_local_data_source.dart
│       │   └── repositories/
│       │       └── profile_repository_impl.dart
│       └── presentation/
│           ├── providers/
│           │   └── profile_providers.dart
│           ├── screens/
│           │   ├── create_profile_screen.dart
│           │   ├── profile_details_screen.dart
│           │   ├── update_profile_screen.dart
│           │   └── switch_profile_screen.dart
│           ├── widgets/
│           └── pages/
```

### Dependency flow

```
UI (screens/widgets)
    ↓
Riverpod Providers (presentation)
    ↓
Usecases (domain)
    ↓
Repository Interfaces (domain)
    ↓
Repository Implementations (data)
    ↓
DataSources (data)
    ↓
DatabaseHelper (core)
    ↓
sqflite
```

- **Domain layer**: pure Dart — no Flutter, no sqflite.
- **Data layer**: depends on domain; models map between entities and database rows.
- **Presentation layer**: depends on domain; Riverpod providers wire usecases to the UI.
- **Core layer**: shared infrastructure (database, navigation, extensions, base classes).

## Features

### Profiles
- **Create Profile**: first-launch screen to set up name and email. If no profile exists, the app routes here automatically.
- **Profile Avatar**: app bar avatar with initials; taps into profile details.
- **Profile Details**: view active profile info.
- **Update Profile**: edit name and email of the active profile.
- **Switch Profile**: list all profiles with an active indicator (green check). Selecting another profile makes it active and refreshes all task views. Includes an option to add a new profile from the same screen.
- **Auto-recovery**: if the DB contains profiles but none is marked active on launch, the app activates the first profile and continues to the task list instead of forcing profile creation.

### Tasks
- **List Tasks**: landing page shows all tasks for the active profile, organized in tabs.
- **Tabs**: All, Pending, Ongoing, Completed, Cancelled — status-based filtering via in-memory filter on the single tasks feed.
- **Add Task**: floating action button opens a form to create a task (title, description). New tasks default to `pending` status and are linked to the active profile.
- **Task Details**: tap any task to view description, status, and full history.
- **Edit Task**: update title and description inline from the task details screen or via the task list popup menu.
- **Change Status**: choose from Pending / Ongoing / Completed / Cancelled via a friendly status picker with icons and descriptions.
- **Delete Task**: confirmation dialog before removal.

### Search
- **Task Search**: app bar search icon opens a `SearchDelegate` that matches title and description. Results render with the same list-tile design as the landing page. Tapping a result navigates to its details.

### History
- **Task History**: every status change is recorded automatically with a timestamp and remark (e.g., "Status changed to completed"). The task details screen shows a chronological history list.

## Database Schema

- **profiles**: `id`, `name`, `email`, `is_active`
- **tasks**: `id`, `title`, `description`, `status`, `profile_id` → `profiles(id)`
- **task_history**: `id`, `task_id` → `tasks(id)`, `date`, `remark`

Foreign keys are enabled (`PRAGMA foreign_keys = ON`). Task and history rows cascade-delete when a profile or task is removed.

## Google Drive Project Folder
- [Project Folder on Google Drive](https://drive.google.com/drive/folders/1VZPbZQfF-w5x-KTh8eRTLLPpT_Pj9fn0?usp=drive_link)

## Download APK

- [Download APK from Google Drive](https://drive.google.com/drive/folders/1VZPbZQfF-w5x-KTh8eRTLLPpT_Pj9fn0?usp=sharing)

## GitHub Repository

- [https://github.com/nkenna/personal-task-manager](https://github.com/nkenna/personal-task-manager)
