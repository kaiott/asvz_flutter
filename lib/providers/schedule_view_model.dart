import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/widgets/lesson_input_dialog.dart';
import 'package:flutter/material.dart';

abstract class ScheduleViewModel extends ChangeNotifier {
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
  // List<Lesson> get lessons => _lessonRepository.all;
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

  Icon get fabIcon;
  String get fabTooptip;
  void onFABClicked(BuildContext context);
  List<Lesson> get lessons;
}

class PastScheduleViewModel extends ScheduleViewModel{
  PastScheduleViewModel({required super.lessonRepository});

  @override
  Icon get fabIcon => Icon(Icons.delete);

  @override
  String get fabTooptip => 'Delete all past lessons';

  @override
  List<Lesson> get lessons => _lessonRepository.all.where((l) => l.isPast()).toList()..sort((a, b) => b.compareTo(a));

  @override
  void onFABClicked(BuildContext context) {
    print('should delete all past lessons');
  }
}

class FutureScheduleViewModel extends ScheduleViewModel{
  FutureScheduleViewModel({required super.lessonRepository});

  @override
  Icon get fabIcon => Icon(Icons.add);

  @override
  String get fabTooptip => 'Add lesson to interested/favourites';

  @override
  List<Lesson> get lessons => _lessonRepository.all.where((l) => !l.isPast()).toList()..sort();

  @override
  void onFABClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LessonInputDialog(
          onSubmit: (lessonId) async {
            final messenger = ScaffoldMessenger.of(context);
            try {
              final lesson = await fetchLesson(lessonId);
              final added = _lessonRepository.add(lesson);
              if (!added) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lesson already added.')),
                );
              }
            } catch (e) {
              messenger.showSnackBar(
                SnackBar(content: Text('Failed to fetch lesson: $e')),
              );
            }
          },
        );
      },
    );
  }
}

class ManagedScheduleViewModel extends ScheduleViewModel{
  ManagedScheduleViewModel({required super.lessonRepository});

  @override
  Icon get fabIcon => Icon(Icons.add);

  @override
  String get fabTooptip => 'Add lesson to managed directly';

  @override
  List<Lesson> get lessons => _lessonRepository.all.where((l) => l.managed && !l.isPast()).toList()..sort();

  @override
  void onFABClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LessonInputDialog(
          onSubmit: (lessonId) async {
            final messenger = ScaffoldMessenger.of(context);
            try {
              final lesson = await fetchLesson(lessonId);
              final added = _lessonRepository.add(lesson);
              final addedToManaged = _lessonRepository.addToManaged(lesson);
              if (!added && addedToManaged) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lesson already added. Changed to managed.')),
                );
              }
              if (!addedToManaged) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lesson already managed.')),
                );
              }
            } catch (e) {
              messenger.showSnackBar(
                SnackBar(content: Text('Failed to fetch lesson: $e')),
              );
            }
          },
        );
      },
    );
  }
}
