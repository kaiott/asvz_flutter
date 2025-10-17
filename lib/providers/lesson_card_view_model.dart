import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonCardViewModel {
  final LessonRepository _lessonRepository;
  final Lesson _lesson;
  final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
  final DateFormat timeFormat = DateFormat("HH:mm");

  LessonCardViewModel({required LessonRepository lessonRepository, required Lesson lesson}) : _lessonRepository = lessonRepository, _lesson = lesson; 

  Lesson get lesson => _lesson;
  String get title => lesson.sportName;
  String get location => lesson.facility;
  String get date => dateFormat.format(lesson.starts);
  String get time => timeFormat.format(lesson.starts);

  Icon get statusIcon {
    const double statusIconSize = 24;
    switch (lesson.status) {
      case LessonStatus.none: return const Icon(Icons.remove_rounded, color: Colors.black, size: statusIconSize,);
      case LessonStatus.past: return const Icon(Icons.history, color: Colors.black, size: statusIconSize,);
      case LessonStatus.enrolled: return const Icon(Icons.check_circle, color: Colors.green, size: statusIconSize,);
      case LessonStatus.beforeEnrollDate: return const Icon(Icons.alarm, color: Colors.black, size: statusIconSize,);
      case LessonStatus.enrollmentAboutToBegin: return const Icon(Icons.alarm, color: Colors.black, size: statusIconSize,);
      case LessonStatus.waitingForSpot: return const Icon(Icons.remove_red_eye, color: Colors.blue, size: statusIconSize,);
      case LessonStatus.enrollPeriodOver: return const Icon(Icons.block, color: Colors.red, size: statusIconSize,);
    }
  }

  void showContextMenu(BuildContext context, Offset? position) async {
    final result = await showMenu(
      context: context,
      position: position != null
          ? RelativeRect.fromLTRB(
              position.dx,
              position.dy,
              position.dx,
              position.dy,
            )
          : const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [!lesson.managed ? const PopupMenuItem(value: 'addToManaged', child: Text('Add to Managed')) : const PopupMenuItem(value: 'removeFromManaged', child: Text('Remove from Managed')), const PopupMenuItem(value: 'delete', child: Text('Delete'))],
    );

    switch (result) {
      case 'delete':
        _lessonRepository.remove(lesson);
      case 'addToManaged':
        _lessonRepository.addToManaged(lesson);
      case 'removeFromManaged':
        _lessonRepository.removeFromManaged(lesson);
      case null:
        break;
      default:
        throw UnimplementedError('no action for $result');
    }
  }
}