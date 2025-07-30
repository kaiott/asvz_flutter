import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/services/lesson_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonProvider extends ChangeNotifier {
  final LessonStore _store = LessonStore();
  String tokenStatus = 'No token';

  LessonProvider() {
    _store.init();
  }

  bool addLesson(Lesson lesson) {
    final added = _store.add(lesson);
    if (added) notifyListeners();
    return added;
  }

  bool removeLesson(Lesson lesson) {
    final removed = _store.remove(lesson.id);
    if (removed) notifyListeners();
    return removed;
  }

  void addToManaged(Lesson lesson) {
    if (_store.changeManaged(lesson.id, true)) notifyListeners();
  }

  void removeFromManaged(Lesson lesson) {
    if (_store.changeManaged(lesson.id, false)) notifyListeners();
  }

  void setStatus(Lesson lesson, LessonStatus status) {
    lesson.status = status;
    notifyListeners();
  }

  void gotToken(String token, DateTime tokenAcquiredAt){
    tokenStatus = 'Have token from ${DateFormat('HH:mm').format(tokenAcquiredAt)}';
    notifyListeners();
  }

  List<Lesson> getLessons() => _store.all;

  List<Lesson> getManagedLessons() => _store.managed;
}