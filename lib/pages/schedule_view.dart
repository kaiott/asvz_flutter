import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/pages/details_view.dart';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/widgets/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  bool Function(Lesson) get filter; // Abstract, needs to be overriden

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  Lesson? selected;

  void _onLessonSelected(Lesson lesson) {
    print("selected lesson ${lesson.id}");
    setState(() {
      selected = lesson;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final LessonProvider lessonProvider = LessonProvider();
    List<Lesson> lessons = context.watch<LessonProvider>().getFilteredLessons(widget.filter);
    // final children = [
    //   for (final lesson in lessons) LessonCard(lesson: lesson),
    // ];
    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final lesson in lessons)
                  GestureDetector(onTap: () => _onLessonSelected(lesson),
                  child: LessonCard(lesson: lesson),)
              ],
            ),
          ),
          DetailsView(lesson: selected),
        ],
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
