import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/services/lesson_agent_manager.dart';
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
    LessonAgentManager().onLessonAdded(lesson);
    return true;
  }

  bool remove(int id) {
    if (!_box.containsKey(id)) return false;
    LessonAgentManager().onLessonRemoved(_box.get(id)!);
    _box.delete(id);
    return true;
  }

  bool changeManaged(int id, bool managed) {
    final lesson = _box.get(id);
    if (lesson == null) return false;
    lesson.managed = managed;
    lesson.save();
    LessonAgentManager().onLessonManagementChange(lesson);
    return true;
  }

  List<Lesson> get all => _box.values.toList()..sort();
  List<Lesson> get managed => _box.values.where((l) => l.managed && !l.isPast()).toList()..sort();
  List<Lesson> filtered(bool Function(Lesson) filter) => _box.values.where(filter).toList()..sort();

  void clear() => _box.clear();
}