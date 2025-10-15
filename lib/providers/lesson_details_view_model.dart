import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:intl/intl.dart';

class LessonDetailsViewModel {
  final LessonRepository lessonRepository;
  final Lesson lesson;
  final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
  final DateFormat timeFormat = DateFormat("HH:mm");

  LessonDetailsViewModel({
    required this.lessonRepository,
    required this.lesson,
  });

  String get title => lesson.sportName;
  String get subtitle => lesson.title;
  String get status => lesson.status.name;
  String get time =>
      "${dateFormat.format(lesson.starts)}\n${timeFormat.format(lesson.starts)} - ${timeFormat.format(lesson.ends)}";
  String get place => "${lesson.facility}\n${lesson.room}";
  String get instructors => lesson.instructors.join(", ");
  String get link => lesson.link;
  Uri get uri => Uri.parse(link);
  String get changeManagedText =>
      lesson.managed ? "Remove from managed" : "Add to managed";
  String get removeText => "Remove";
  String get optionText => "Option";

  void onChangeManagedPressed() {
    lessonRepository.changeManaged(lesson);
  }

  void onRemovePressed() {
    lessonRepository.remove(lesson);
  }

  void onOptionPressed() {
    print("hello");
  }
}
