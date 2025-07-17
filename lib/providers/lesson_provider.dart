import 'package:asvz_autosignup/models/lesson.dart';

class LessonProvider {
  static final LessonProvider _instance = LessonProvider._internal();
  factory LessonProvider() => _instance;

  LessonProvider._internal();

  final Map<int, Lesson> lessons = <int, Lesson>{};

  bool addLesson(Lesson lesson) {
    if (lessons.containsKey(lesson.id)) {
      return false;
    }
    lessons[lesson.id] = lesson;
    return true;
  }

  List<Lesson> getLessons() {
    return [for (final id in lessons.keys.toList()..sort()) lessons[id]!];
  }
}