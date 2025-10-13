import 'dart:async';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/services/lesson_agent.dart';
import 'package:intl/intl.dart';

import '../models/lesson.dart';

enum TokenStatus {
  none,
  valid,
  expired,
  acquiryFailed,
}

class LessonAgentManager {
  static final LessonAgentManager _instance = LessonAgentManager._internal();
  factory LessonAgentManager() => _instance;
  LessonAgentManager._internal() {start();}

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
  String? _errorMessage;
  TokenStatus _tokenStatus = TokenStatus.none;

  // LessonAgent tracking
  final Map<int, LessonAgent> _activeAgents = {};

  Future<void> start() async {
    while (true) {
      print('needs token: $_needsToken');
      checkTokenValid();
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

  /* check if status of token is still valid if it was valid (i.e. transition valid -> expired)
  Any other token status update is handled by the _ensureToken function  */
  bool checkTokenValid() {
    if (_tokenStatus != TokenStatus.valid) return false;
    // if status is valid, then _tokenAcquiredAt is guaranteed not null
    if (DateTime.now().isAfter(_tokenAcquiredAt!.add(Duration(hours: 1, minutes: 55)))) {
      _tokenStatus = TokenStatus.expired;
      return false;
    }
    print('token acq: ${DateFormat('HH:mm'). format(_tokenAcquiredAt!)}');
    return true;
  }

  Future<void> _ensureToken() async {
    if (!checkTokenValid()) {
      try {
        _accessToken = await updateAccessToken();
        _errorMessage = null;
        _tokenStatus = TokenStatus.valid;
      } on Exception catch(e) {
        _accessToken = null;
        _errorMessage = e.toString();
        _tokenStatus = TokenStatus.acquiryFailed;
      }
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
