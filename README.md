# Todo App

A local-first Flutter to-do app with recurring tasks, scheduled reminders, and light/dark theming.

## Features

- Create, edit, complete, and delete tasks with a title, note, date, start/end time, color, and reminder offset
- Recurring tasks: None, Daily, Weekly, Monthly, Yearly
- Local push notifications scheduled per task, respecting its recurrence rule
- Light/dark theme, persisted across launches
- Fully offline — all data lives in a local SQLite database on-device

## Architecture

This project follows a layered / clean-architecture-inspired structure:

```
lib/
├── domain/                  # Framework-agnostic business objects
│   ├── entities/task.dart       (Task, RepeatType, TaskColor)
│   └── repositories/task_repository.dart   (abstract interface)
├── data/                    # Everything storage-related
│   ├── models/task_dto.dart              (Task <-> SQLite row mapping)
│   ├── datasources/task_local_data_source.dart  (raw SQLite access)
│   └── repositories/task_repository_impl.dart   (implements the domain interface)
├── presentation/
│   ├── providers/task_providers.dart     (Riverpod: TaskListNotifier)
│   ├── pages/                            (screens)
│   └── widgets/                          (reusable UI pieces)
└── core/
    ├── Theme/                            (colors, text styles, ThemeData)
    ├── services/                         (notifications, theme persistence, permissions)
    └── utils/                            (responsive sizing helpers)
```

**Why a repository interface?** The presentation layer only ever talks to
`TaskRepository` (an abstract class), never to SQLite directly. This means
`TaskListNotifier` can be unit tested against an in-memory fake repository
with no real database involved — see `test/presentation/task_list_notifier_test.dart`.

## Tech stack

| Concern | Choice |
|---|---|
| State management | [Riverpod](https://riverpod.dev) (`AsyncNotifier` for the task list) |
| Navigation & UI utilities | [GetX](https://pub.dev/packages/get) (`Get.to`, `Get.snackbar`, `Get.dialog`, `Get.bottomSheet`) |
| Local storage | `sqflite` (SQLite) for tasks, `get_storage` for simple key/value flags |
| Notifications | `flutter_local_notifications` + `timezone` |
| Localization | `flutter_localizations` + ARB files (English, Arabic — partial coverage, see below) |

> **Note on mixed state management:** Riverpod owns app state (the task
> list); GetX is used purely for navigation and UI utility calls. This was
> a deliberate scoping decision during the GetX → Riverpod migration to
> limit blast radius — see the project history for the full reasoning.

## Getting started

```bash
flutter pub get   # also runs `flutter gen-l10n` to generate AppLocalizations
flutter run
```

## Testing

```bash
flutter test
```

Test coverage includes:
- `test/domain/task_dto_test.dart` — pure mapping/serialization logic, no plugins required
- `test/data/task_repository_impl_test.dart` — the repository against a real in-memory SQLite DB (via `sqflite_common_ffi`)
- `test/presentation/task_list_notifier_test.dart` — `TaskListNotifier` against a fake `TaskRepository`

CI (`.github/workflows/flutter_ci.yml`) runs formatting checks, `flutter analyze`, and `flutter test` on every push/PR to `main`.

## Localization status

Infrastructure (ARB files, `flutter gen-l10n` config, `AppLocalizations`
wired into `MaterialApp`) is in place for English and Arabic. Only a few
representative strings have been migrated so far (see `home_page.dart`'s
app bar title and empty-state messages) — extending this to the rest of
the app's strings is mechanical follow-up work following the same pattern:
add the key to both `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`, then
reference it via `AppLocalizations.of(context)!.yourKey`.

## Known follow-ups

- A one-off ("None" repeat) task whose scheduled time has already passed
  today will fire its notification immediately rather than being skipped —
  documented in `notification_services.dart`, left as a product decision
  rather than a pure bug fix.
- Accessibility: tooltips are in place on icon buttons; a full semantics
  and dark-mode contrast audit hasn't been done yet.
