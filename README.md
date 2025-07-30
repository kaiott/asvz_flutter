# ASVZ Autosignup App – Project Description (2025 Edition)

This Flutter app helps users automatically enroll in university sports lessons at ASVZ (Akademischer Sportverband Zürich). It replicates and improves upon a previous system based on a Python+Selenium backend with a Java Android frontend. The goal is now to run everything locally on-device using HTTP APIs and persistent storage, with a cross-platform UI.

## ✅ Current Implementation

- **Authentication (OAuth2)**:
  - Fully reimplemented in Dart using direct HTTP requests.
  - Tokens are acquired via a mock `assets/credentials.json` file during development.

- **Architecture**:
  - `Lesson`: a Hive-persisted model with a `managed` flag and `status`.
  - `LessonAgent`: per-lesson class that handles enrollment lifecycle (mirroring Python’s threaded `ASVZManager`).
  - `LessonAgentManager`: singleton that manages agents and handles shared token acquisition.
  - `LessonProvider`: `ChangeNotifier`-based state layer for UI.
  - `api_service.dart`: all networking logic.

- **Lifecycle Logic**:
  - Each `LessonAgent` monitors a lesson’s availability and enrollment window.
  - Lessons marked as `managed` receive an agent on addition or at app startup.
  - Token acquisition runs in the background only if needed, shared across agents.

## 🔜 Upcoming Features & Challenges

1. **Persistent token storage**:
   - Store `accessToken` and `acquiredAt` securely (e.g. via `flutter_secure_storage`).
   - Reuse token across app restarts if still valid.

2. **Agent rehydration on startup**:
   - Load all `managed == true` lessons from Hive on app launch.
   - Instantiate corresponding `LessonAgent`s automatically.

3. **Background execution**:
   - Enable agents to run even when the app is in the background or closed (especially on Android).
   - Likely involves `android_foreground_service` or `flutter_background`.

4. **Credential UI and security**:
   - Implement login screen for secure user input.
   - Store credentials only on device, never on a server.

5. **User interface improvements**:
   - Enhanced lesson list UI and state feedback.
   - Ability to export/import lesson data as JSON.
   - Manual enrollment trigger for non-managed lessons.

6. **Improved state flow**:
   - Consider finer-grained state updates or migration to a more robust state management approach (e.g. Riverpod or Bloc), if needed.

## 🧩 Notes

- The entire app runs locally with no backend.
- Design is modular: UI communicates only with `LessonProvider`, which abstracts storage and agent logic.
- `LessonAgentManager` uses `Future`-based loops instead of threads.
