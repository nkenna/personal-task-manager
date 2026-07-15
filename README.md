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

## Challenges

### 1. Persistence choice: Hive was no longer an option
I initially wanted to use **Hive** for local storage because of its lightweight, NoSQL-like API and strong Flutter integration. However, at the time of building this project, the Hive package on pub.dev was no longer being actively maintained. That made it a risky long-term choice for a personal project meant to be reliable offline-first. I switched to **sqflite** instead, which gave me:
- A mature, well-maintained SQLite wrapper
- Full control over schema and foreign keys
- Compatibility with standard SQL tooling and future migration paths

The trade-off was more boilerplate (tables, queries, migrations), but it kept the data layer stable and explicit.

### 2. No Figma/UI design: designing UX from scratch
I did not have a Figma file or a designer's input for this project. Every screen — from the first-launch profile creation to the task list tabs, status chips, avatars, and search — was designed by hand. That meant spending extra time thinking through:
- How a user should move between profile switching and task management
- Whether status changes should be inline, dialog-based, or navigational
- How search results should relate to the existing list UI
- Color and icon choices that feel consistent without a design system

Without a reference, I iterated on the UI directly in code, refining spacing, typography, and component reuse (e.g., shared `TaskListTile`) along the way. This slowed initial development but resulted in a cohesive, self-consistent interface.

## Assumptions

- **Profiles are required to personalize task management**: I assumed the app would be used by more than one person on the same device, or by one person managing distinct contexts (personal vs work). Without a profile layer, every task would live in one flat list, with no way to separate or switch contexts. Profiles give each user or context their own task space, active-profile switching, and scoped task views — making the app genuinely multi-user and multi-context from day one.
- **Status tracking is part of the core workflow**: I assumed users would want to move tasks through stages (Pending → Ongoing → Completed/Cancelled) and keep a record of those transitions. That assumption drove the `task_history` table and the status picker UI.
- **Offline-first local storage**: I assumed the app would be used primarily offline, so a local SQLite database was sufficient. No cloud sync was planned initially, which kept the architecture simple and dependency-free.

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

## Testing

The project includes unit tests for model mappings, string extensions, and usecases. Run them with:

```bash
flutter test
```

**Coverage**
- **Model mapping**: `TaskModel`, `ProfileModel`, `TaskHistoryModel` — round-trip `fromMap`/`toMap` and entity conversion.
- **String extension**: `capitalizeFirst` behavior for empty, lowercase, and already-capitalized strings.
- **Profile usecases** (fake repository): add, update, delete, list, get active, set active.
- **Task usecases** (fake repository): add, edit, delete, list, change status, search.

Tests use in-memory fake repositories — no database or Flutter widget tests are required.

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
