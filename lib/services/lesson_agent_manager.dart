import 'dart:async';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/services/lesson_agent.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';

class LessonAgentManager {
  static final LessonAgentManager _instance = LessonAgentManager._internal();
  factory LessonAgentManager() => _instance;
  LessonAgentManager._internal();

  LessonProvider? _provider;

  void injectProvider(LessonProvider provider) {
    _provider = provider;
  }

  LessonProvider get _requireProvider {
    if (_provider == null) throw StateError('LessonProvider not injected');
    return _provider!;
  }
  
  // Token and timing
  String? _accessToken;
  DateTime? _tokenAcquiredAt;

  // LessonAgent tracking
  final Map<int, LessonAgent> _activeAgents = {};

  Future<void> start() async {
    while (true) {
      if (_needsToken) await _ensureToken();
      await Future.delayed(Duration(seconds: 60));
    }
  }

  void onLessonAdded(Lesson lesson) {
    onLessonManagementChange(lesson);
  }
  
  void onLessonManagementChange(Lesson lesson) {
    if (lesson.managed) {
      _activeAgents.putIfAbsent(lesson.id, () => LessonAgent(lesson: lesson, provider: _requireProvider));
      print('Added LessonAgent for lesson ${lesson.id}');
    } else {
      onLessonRemoved(lesson);
    }
  }

  void onLessonRemoved(Lesson lesson) {
    if (_activeAgents.containsKey(lesson.id)) {
      _activeAgents[lesson.id]!.kill();
      _activeAgents.remove(lesson.id);
    }
  }

  bool get _needsToken {
    return _activeAgents.values.any((agent) => agent.needsToken());
  } // true if any agent needs token

  bool get isTokenValid {
    if (_tokenAcquiredAt != null) {
      return DateTime.now().isBefore(_tokenAcquiredAt!.add(Duration(hours: 1, minutes: 55)));
    }
    return false;
  }

  Future<void> _ensureToken() async {
    if (!isTokenValid) {
      _accessToken = await updateAccessToken();
      _tokenAcquiredAt = DateTime.now();
      print('Token refreshed at $_tokenAcquiredAt');
      _requireProvider.gotToken(_accessToken!, _tokenAcquiredAt!);
    }
  }

  Future<String> get accessToken async {
    await _ensureToken();
    return _accessToken!;
  }
}
