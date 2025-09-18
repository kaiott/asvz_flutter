import 'package:asvz_autosignup/models/lesson.dart';
import 'package:asvz_autosignup/pages/details_view.dart';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/widgets/lesson_card.dart';
import 'package:asvz_autosignup/widgets/lesson_input_dialog.dart';
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

  void _addButtonClicked() {
    showDialog(
      context: context,
      builder: (context) {
        return LessonInputDialog(
          onSubmit: (lessonId) async {
            final messenger = ScaffoldMessenger.of(context);
            final lessonProvider = context.read<LessonProvider>();
            try {
              final lesson = await fetchLesson(lessonId);
              final added = lessonProvider.addLesson(lesson);
              if (!added) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Lesson already added.')),
                );
              }
              //final token = await updateAccessToken();
              //print(token);
              //setState(() {});
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

  void _onLessonSelected(Lesson? lesson) {
    if (lesson == null) {
      print("deselected lesson");
    } else {
      print("selected lesson ${lesson.id}");
    }
    setState(() {
      selected = lesson;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Lesson> lessons = context.watch<LessonProvider>().getFilteredLessons(
      widget.filter,
    );
    if (!lessons.contains(selected)) {
      selected = null;
    }
    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Scaffold(
              body: GestureDetector(
                behavior: HitTestBehavior.opaque, // important!
                onTap: () => _onLessonSelected(null),
                child: SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final lesson in lessons)
                        GestureDetector(
                          onTap: () => _onLessonSelected(lesson),
                          child: LessonCard(
                            lesson: lesson,
                            selected: lesson == selected,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
            onPressed: _addButtonClicked,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
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
  bool Function(Lesson) get filter =>
      (l) => l.managed && !l.isPast();
}

class PastPage extends ScheduleView {
  const PastPage({super.key});

  @override
  bool Function(Lesson) get filter =>
      (l) => l.isPast();
}

class InterestedPage extends ScheduleView {
  const InterestedPage({super.key});

  @override
  bool Function(Lesson) get filter =>
      (l) => !l.isPast();
}
