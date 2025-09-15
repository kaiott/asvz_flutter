import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/widgets/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  bool Function(Lesson) get filter; // Abstract, needs to be overriden

  @override
  Widget build(BuildContext context) {
    //final LessonProvider lessonProvider = LessonProvider();
    List<Lesson> lessons = context.watch<LessonProvider>().getFilteredLessons(filter);
    final children = [
      for (final lesson in lessons) LessonCard(lesson: lesson),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class UpcomingPage extends ScheduleView {
  const UpcomingPage({super.key});

  @override
  bool Function(Lesson) get filter => (l) => l.managed && !l.isPast();
}

class PastPage extends ScheduleView {
  const PastPage({super.key});

  @override
  bool Function(Lesson) get filter => (l) => l.isPast();
}

class InterestedPage extends ScheduleView {
  const InterestedPage({super.key});

  @override
  bool Function(Lesson) get filter => (l) => !l.isPast();
}
