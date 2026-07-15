# Clean Architecture for the PTM app (Riverpod + sqflite)

The goal of clean architecture is to separate **what the app does** (business rules)
from **how it does it** (framework, DB, UI). Dependencies only point inward — the UI
knows about the domain, but the data layer doesn't know about the UI.

## Recommended layer structure

```
lib/
├── core/
│   ├── database/        # sqflite setup (you already have DatabaseHelper here)
│   ├── errors/          # Failure/Exception classes
│   └── usecase/         # base usecase (optional)
├── features/
│   └── tasks/           # one folder per feature (e.g. tasks, projects)
│       ├── data/
│       │   ├── models/         # TaskModel (fromMap/toMap) - sqflite row <-> object
│       │   ├── datasources/    # local_data_source: raw sqflite CRUD via DatabaseHelper
│       │   └── repositories/   # TaskRepositoryImpl (implements domain repo)
│       ├── domain/
│       │   ├── entities/       # Task (pure Dart, no flutter/sqflite)
│       │   ├── repositories/   # TaskRepository (abstract interface)
│       │   └── usecases/       # getTasks, addTask, deleteTask
│       └── presentation/
│           ├── providers/      # Riverpod: StateNotifier/AsyncNotifier wiring usecases
│           ├── widgets/
│           └── pages/
```

## The dependency rule (most important)

- **domain** depends on nothing (pure Dart).
- **data** depends on domain (implements its interfaces) + uses `core/database`.
- **presentation** depends on domain + Riverpod.
- UI → providers → usecases → repository (interface) → datasource → `DatabaseHelper`.

## How the pieces map to your stack

1. **Entity** (domain): plain `Task` class, no annotations, no sqflite import.
2. **Model** (data): `TaskModel extends/implements Task` with `fromMap()`, `toMap()`
   to serialize for sqflite.
3. **LocalDataSource** (data): wraps `DatabaseHelper` — does the actual
   `insert/query/update/delete` and returns `TaskModel` lists. This is the only place
   that touches sqflite directly.
4. **Repository interface** (domain): `abstract class TaskRepository` declaring
   `Future<List<Task>> getTasks()`.
5. **Repository impl** (data): `TaskRepositoryImpl` calls the datasource and converts
   models → entities.
6. **Usecase** (domain): one class per action (`GetTasks`, `AddTask`). Keeps business
   logic out of providers.
7. **Riverpod provider** (presentation): `final tasksProvider =
   AsyncNotifierProvider(...)` that calls the usecase and exposes state to the UI.
   Inject the repo via `ref.read(taskRepositoryProvider)`.

## Key principles to keep it clean

- **Inject dependencies at the top**: in `bootstrap.dart`, register repos/datasources
  with Riverpod `Provider` overrides. The rest of the app only sees interfaces.
- **Return `Either<Failure, T>` or throw domain exceptions** from the data layer
  instead of leaking `DatabaseException` into the UI; map sqflite errors in the
  datasource.
- **Repository = single source of truth**: UI/providers never call `DatabaseHelper`
  directly.
- **One feature per folder** so adding "projects" later means copying the `tasks`
  structure, not editing global files.
- **Keep `DatabaseHelper` generic** (which it already is) — schema/table details
  belong in the datasource, not the helper.

## Why this fits Riverpod + sqflite

Riverpod providers naturally sit at the boundary between presentation and domain, and
dependency injection via providers replaces manual DI — no need for `get_it` unless you
want it. sqflite stays fully isolated in `core/database` + feature datasources, so you
could swap to `drift` or an API later without touching the UI or domain.

This keeps tests easy: domain (pure Dart) and usecases testable with a fake repository,
and providers testable with a mocked repo.
