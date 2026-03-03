# ASVZ Autosignup App – Project Description (2025 Edition)

This Flutter app helps users automatically enroll in university sports lessons at ASVZ (Akademischer Sportverband Zürich). It replicates and improves upon a previous system based on a Python+Selenium backend with a Java Android frontend. The goal is now to run everything locally on-device using HTTP APIs and persistent storage, with a cross-platform UI.

## ✅ Current Implementation

- **Authentication (OAuth2)**:
  - Fully reimplemented in Dart using direct HTTP requests (`api_service.dart`).
  - Credentials are currently read from a hardcoded `assets/credentials.json` file (no login UI yet).
  - Token expires after ~2 hours; the app proactively refreshes it at 1h55m via an in-memory expiry timer.

- **Architecture**:
  - `Lesson`: Hive-persisted model with a `managed` flag. `status` (a `LessonStatus` enum) is transient — not persisted, reset on each app start.
  - `LessonDatabaseService` / `HiveLessonDatabaseService`: abstract interface + Hive implementation for lesson CRUD.
  - `LessonAgent`: per-lesson class that handles the enrollment lifecycle. Starts automatically on construction, sleeps until 5 minutes before the enrollment window opens, then polls for free spots and calls `tryEnroll`.
  - `LessonRepository` (ChangeNotifier): the central state manager. Owns the lessons map, manages active `LessonAgent`s, handles add/remove/managed toggles, persists via `LessonDatabaseService`, and listens to `TokenRepository` for token expiry.
  - `TokenRepository`: manages the token lifecycle using a `ValueNotifier<TokenStatus>`. Shared across all agents via `ensureToken()`.
  - ViewModels in `providers/`: `ScheduleViewModel` (abstract + 3 concrete subclasses for Interested/Managed/Past tabs), `LessonCardViewModel`, `LessonDetailsViewModel`, `TokenViewModel`.
  - `api_service.dart`: all networking logic (fetch lesson, enroll, check enrollment, OAuth2 flow).

- **Lifecycle Logic**:
  - Each `LessonAgent` monitors a lesson's enrollment window using `Future.delayed`.
  - On app startup, `LessonRepository` rehydrates agents for all lessons stored with `managed == true`.
  - Token acquisition is shared: `LessonRepository` calls `tokenRepository.ensureToken()` when any agent needs a token or when a token expires.

- **UI**:
  - `NavigationRail` with four tabs: Interested (all upcoming lessons), Managed (auto-enroll active), Past, and Token/Log.
  - `ScheduleView` is reused across the first three tabs, driven by a tab-specific `ScheduleViewModel`.
  - `LessonCard` with right-click / long-press context menu (add to managed, remove from managed, delete).
  - `LessonDetailsView` side panel with lesson info, link to ASVZ, and action buttons.
  - `LessonInputDialog` for adding a lesson by numeric ID.

## 🔜 Upcoming Features & Challenges

1. **Persistent token storage**:
   - Store `accessToken` and `acquiredAt` securely (e.g. via `flutter_secure_storage`).
   - Reuse a valid token across app restarts.

2. **Credential UI and security**:
   - Implement a login screen for secure user input.
   - Store credentials only on device, never on a server.
   - Replace the current `assets/credentials.json` approach.

3. **Background execution**:
   - Enable agents to run even when the app is in the background or closed (especially on Android).
   - Likely involves `android_foreground_service` or `flutter_background`.

4. **Manual status refresh**:
   - A refresh action that re-checks the true enrollment status of all managed lessons from the ASVZ API.
   - Can be implemented by killing and restarting all active agents (effectively "forgetting" stale status).

5. **User interface improvements**:
   - Ability to export/import lesson data as JSON.
   - The "Option" button in the detail panel is a placeholder with no functionality yet.
   - The "Log" tab currently shows only token status, not a proper event log.

## 🐛 Known Bugs

- **Device sleep breaks the expiry timer**: `expiryTimer()` uses `Future.delayed`, which may fire early if the device sleeps. This can cause premature token expiry detection.
- **`tryEnroll` POST is fire-and-forget**: The enrollment POST request always times out, so it is intentionally not awaited. Instead, enrollment success is checked via a separate GET after a 5-second delay. This is fragile.

## 🧩 Notes

- The entire app runs locally with no backend.
- UI communicates with `LessonRepository`, which abstracts storage and agent logic.
- Agents use `Future.delayed`-based loops instead of threads.
- `LessonStatus` is intentionally not persisted. The true enrollment status can change externally (e.g. manually unenrolling on the ASVZ website), so persisting it would risk showing stale state. On startup, status is treated as unknown and agents re-derive it. The trade-off is that status may also drift while the app is running, which a future manual refresh feature would address.

## Flutter cheatsheet
`dart run build_runner build --delete-conflicting-outputs` recreates lesson.g.dart if model Lesson is updated with fields.
