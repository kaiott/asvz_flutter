import 'package:asvz_autosignup/models/lesson.dart';
import 'package:hive/hive.dart';

abstract interface class LessonDatabaseService {
  Map<int, Lesson> loadAll();
  void save(Lesson lesson);
  void delete(Lesson lesson);
}

class HiveLessonDatabaseService implements LessonDatabaseService {
  final Box<Lesson> _box;

  HiveLessonDatabaseService._(this._box);

  static Future<HiveLessonDatabaseService> create() async {
    final box = await Hive.openBox<Lesson>('lessons');
    return HiveLessonDatabaseService._(box);
  }

  @override
  Map<int, Lesson> loadAll() {
    return Map<int, Lesson>.from(_box.toMap());
  }

  @override
  void save(Lesson lesson) {
    _box.put(lesson.id, lesson);
  }

  @override
  void delete(Lesson lesson) {
    _box.delete(lesson.id);
  }
}