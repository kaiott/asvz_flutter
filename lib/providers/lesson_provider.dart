import 'package:asvz_autosignup/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonProvider extends ChangeNotifier{
  final Map<int, Lesson> lessons = <int, Lesson>{};

  bool addLesson(Lesson lesson) {
    if (lessons.containsKey(lesson.id)) {
      return false;
    }
    lessons[lesson.id] = lesson;
    notifyListeners();
    return true;
  }

  List<Lesson> getLessons() => lessons.values.toList()..sort();
}