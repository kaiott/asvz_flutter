import 'package:asvz_autosignup/models/lesson.dart';

class LessonStore {
  static final LessonStore _instance = LessonStore._internal();
  factory LessonStore() => _instance;
  LessonStore._internal();

  final Map<int, Lesson> _lessons = {};

  bool add(Lesson lesson) {
    if (_lessons.containsKey(lesson.id)) return false;
    _lessons[lesson.id] = lesson;
    return true;
  }

  List<Lesson> get all => _lessons.values.toList()..sort();
}