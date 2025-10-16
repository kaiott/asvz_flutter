import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:asvz_autosignup/services/api_service.dart';

class LessonAgent { //Also a service I think
  final Lesson lesson;
  final LessonRepository lessonRepository;
  final TokenRepository tokenRepository;
  bool cancelFlag = false;

  LessonAgent({required this.lesson, required this.lessonRepository, required this.tokenRepository}) {
    start();
  }

  bool needsToken() {
    return lesson.status == LessonStatus.enrollmentAboutToBegin || lesson.status == LessonStatus.waitingForSpot;
  }

  Future<void> start() async {
    int numFreeSpots = await fetchNumberOfFreeSpots(lesson.id);
    _setStatus(LessonStatus.beforeEnrollDate);
    await waitUntil(lesson.enrollmentFrom.add(Duration(minutes: -5)));
    if (cancelFlag) {
      return;
    }
    _setStatus(LessonStatus.enrollmentAboutToBegin);
    await waitUntil(lesson.enrollmentFrom);
    if (cancelFlag) {
      return;
    }
    bool enrolled = false;
    while (!enrolled && DateTime.now().isBefore(lesson.enrollmentUntil) && !cancelFlag) {
      _setStatus(LessonStatus.waitingForSpot);
      numFreeSpots = await fetchNumberOfFreeSpots(lesson.id);
      if (numFreeSpots > 0) {
        print('trying to enroll with ${await tokenRepository.ensureToken()}');
        enrolled = await tryEnroll(lesson.id, (await tokenRepository.ensureToken())!);
        print('tryenroll returned $enrolled');
      } else {
        print('waiting since $numFreeSpots free spots');
        await Future.delayed(Duration(seconds: 2));
      }
    }

    if (enrolled) {
      _setStatus(LessonStatus.enrolled);
    } else if (cancelFlag) {
      return;
      //_setStatus(LessonStatus.none);
    } else {
      _setStatus(LessonStatus.enrollPeriodOver);
    }
  }

  void _setStatus(LessonStatus status) {
    print('lesson ${lesson.id} new status $status');
    lessonRepository.setLessonStatus(lesson, status);
  }

  void kill() {
    cancelFlag = true;
    _setStatus(LessonStatus.none); // if back to unmanaged, status agnostic even if enrolled, maybe change later.
  }

  Future<void> waitUntil(DateTime until) async {
    Duration duration = until.difference(DateTime.now());
    await Future.delayed(duration.isNegative ? Duration.zero : duration);
  }
}