import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/services/lesson_agent_manager.dart';

class LessonAgent {
  final Lesson lesson;
  final LessonProvider provider;
  bool cancelFlag = false;

  LessonAgent({required this.lesson, required this.provider}) {
    start();
  }

  bool needsToken() {
    return lesson.status == LessonStatus.enrollmentAboutToBegin || lesson.status == LessonStatus.waitingForSpot;
  }

  Future<void> start() async {
    int numFreeSpots = await fetchNumberOfFreeSpots(lesson.id);
    _setStatus(LessonStatus.beforeEnrollDate);
    await waitUntil(lesson.enrollmentFrom.add(Duration(minutes: -5)));
    _setStatus(LessonStatus.enrollmentAboutToBegin);
    await waitUntil(lesson.enrollmentFrom);
    bool enrolled = false;
    while (!enrolled && DateTime.now().isBefore(lesson.enrollmentUntil) && !cancelFlag) {
      _setStatus(LessonStatus.waitingForSpot);
      numFreeSpots = await fetchNumberOfFreeSpots(lesson.id);
      if (numFreeSpots > 0) {
        print('trying to enroll with ${await LessonAgentManager().accessToken}');
        enrolled = await tryEnroll(lesson.id, await LessonAgentManager().accessToken);
        print('tryenroll returned $enrolled');
      } else {
        print('waiting since $numFreeSpots free spots');
        await Future.delayed(Duration(seconds: 2));
      }
    }

    if (enrolled) {
      _setStatus(LessonStatus.enrolled);
    } else if (cancelFlag) {
      _setStatus(LessonStatus.none);
    } else {
      _setStatus(LessonStatus.enrollPeriodOver);
    }
  }

  void _setStatus(LessonStatus status) {
    print('lesson ${lesson.id} new status $status');
    provider.setStatus(lesson, status);
  }

  void kill() {
    cancelFlag = true;
  }

  Future<void> waitUntil(DateTime until) async {
    Duration duration = until.difference(DateTime.now());
    await Future.delayed(duration);
  }
}