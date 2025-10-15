import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';

class ScheduleViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;
  Lesson? _selected;

  ScheduleViewModel({required LessonRepository lessonRepository}) : _lessonRepository = lessonRepository {
    _lessonRepository.addListener(_onLessonsChanged);
  }

  void _onLessonsChanged() {
    if (!lessons.contains(_selected)) _selected = null; // if the current selected one has been removed
    notifyListeners();
  }

  bool get showDetailsView => _selected != null;
  List<Lesson> get lessons => _lessonRepository.all;
  Lesson? get selected => _selected;

  void select(Lesson? lesson) {
    if (lesson == _selected) { // if the current selected is clicked/"selected" again unselect
      _selected = null;
    } else {
      _selected = lesson; // also sets selected to null if we select with null
    }
    print('selected lesson in vm func ${lesson?.id}');
    notifyListeners();
  }

  @override
  void dispose() {
    _lessonRepository.removeListener(_onLessonsChanged);
    super.dispose();
  }
}