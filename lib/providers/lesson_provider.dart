import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/services/lesson_store.dart';
import 'package:flutter/material.dart';

class LessonProvider extends ChangeNotifier {
  final LessonStore _store = LessonStore();
  final Map<int, Lesson> lessons = <int, Lesson>{};

  bool addLesson(Lesson lesson) {
    final added = _store.add(lesson);
    if (added) notifyListeners();
    return added;
  }

  List<Lesson> getLessons() => _store.all;
}