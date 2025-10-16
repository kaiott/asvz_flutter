import 'dart:async';

import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:asvz_autosignup/services/lesson_agent2.dart';
import 'package:asvz_autosignup/services/lesson_database_service.dart';
import 'package:flutter/foundation.dart';

class LessonRepository with ChangeNotifier {
  final TokenRepository tokenRepository;
  final LessonDatabaseService lessonDatabaseService;
  late final Map<int, Lesson> _lessons;

  // public getters
  List<Lesson> get all => _lessons.values.toList()..sort();
  List<Lesson> get managed =>
      _lessons.values.where((l) => l.managed && !l.isPast()).toList()..sort();
  List<Lesson> filtered(bool Function(Lesson) filter) =>
      _lessons.values.where(filter).toList()..sort();

  // LessonAgent tracking
  final Map<int, LessonAgent2> _activeAgents = {};

  LessonRepository({required this.tokenRepository, required this.lessonDatabaseService}) {
    tokenRepository.tokenStatusListenable.addListener(_onTokenStatusChanged);
    _lessons = lessonDatabaseService.loadAll(); // Load lessons from database
  }

  bool add(Lesson lesson) {
    if (_lessons.containsKey(lesson.id)) return false;
    _lessons[lesson.id] = lesson;
    lessonDatabaseService.save(lesson);
    notifyListeners();
    return true;
  }

  bool remove(Lesson lesson) {
    if (!_lessons.containsKey(lesson.id)) return false;
    _killAgent(lesson);
    _lessons.remove(lesson.id);
    lessonDatabaseService.delete(lesson);
    notifyListeners();
    return true;
  }

  bool addToManaged(Lesson lesson) {
    if (!_lessons.containsKey(lesson.id) || lesson.managed) return false;
    lesson.managed = true;
    _activeAgents.putIfAbsent(
      lesson.id,
      () => LessonAgent2(
        lesson: lesson,
        lessonRepository: this,
        tokenRepository: tokenRepository,
      ),
    );
    lessonDatabaseService.save(lesson);
    notifyListeners();
    return true;
  }

  bool removeFromManaged(Lesson lesson) {
    if (!_lessons.containsKey(lesson.id) || !lesson.managed) return false;
    lesson.managed = false;
    _killAgent(lesson);
    lessonDatabaseService.save(lesson);
    notifyListeners();
    return true;
  }

  bool changeManaged(Lesson lesson) {
    return lesson.managed ? removeFromManaged(lesson) : addToManaged(lesson);
  }

  bool get _needsToken {
    return _activeAgents.values.any((agent) => agent.needsToken());
  } // true if any agent needs token

  void _killAgent(Lesson lesson) {
    if (_activeAgents.containsKey(lesson.id)) {
      _activeAgents[lesson.id]!.kill();
      _activeAgents.remove(lesson.id);
    }
  }

  void _onTokenStatusChanged() {
    if (tokenRepository.status == TokenStatus.expired) {
      _ensureTokenIfNeeded();
    }
  }

  void setLessonStatus(Lesson lesson, LessonStatus status) {
    lesson.status = status;
    notifyListeners();
    _ensureTokenIfNeeded();
  }

  void _ensureTokenIfNeeded() {
    if (_needsToken) unawaited(tokenRepository.ensureToken());
  }

  @override
  void dispose() {
    tokenRepository.tokenStatusListenable.removeListener(_onTokenStatusChanged);
    super.dispose();
  }
}
