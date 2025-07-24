import 'package:asvz_autosignup/models/lesson.dart';
import 'package:hive/hive.dart';

class LessonStore {
  static final LessonStore _instance = LessonStore._internal();
  factory LessonStore() => _instance;
  LessonStore._internal();

  late final Box<Lesson> _box;

  Future<void> init() async {
    _box = Hive.box<Lesson>('lessons');
  }

  bool add(Lesson lesson) {
    if (_box.containsKey(lesson.id)) return false;
    _box.put(lesson.id, lesson);
    return true;
  }

  bool remove(int id) {
    if (!_box.containsKey(id)) return false;
    _box.delete(id);
    return true;
  }

  List<Lesson> get all => _box.values.toList()..sort();

  void clear() => _box.clear();
}