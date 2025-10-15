import 'package:asvz_autosignup/pages/lesson_details_view.dart';
import 'package:asvz_autosignup/providers/lesson_details_view_model.dart';
import 'package:asvz_autosignup/providers/schedule_view_model.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:asvz_autosignup/widgets/lesson_card.dart';
import 'package:asvz_autosignup/widgets/lesson_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleView2 extends StatelessWidget {
  const ScheduleView2({super.key});

  void _addButtonClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LessonInputDialog(
          onSubmit: (lessonId) async {
            final messenger = ScaffoldMessenger.of(context);
            final lessonRepository = context.read<LessonRepository>();
            try {
              final lesson = await fetchLesson(lessonId);
              final added = lessonRepository.add(lesson);
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

  // void _addButtonClicked() {
  //   print('add button clicked');
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, vm, child) => Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Scaffold(
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque, // important!
                  onTap: () => vm.select(null),
                  child: SizedBox.expand(
                    child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final lesson in vm.lessons)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => vm.select(lesson),
                                child: LessonCard(
                                  lesson: lesson,
                                  selected: lesson == vm.selected,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _addButtonClicked(context),
                  tooltip: 'Add',
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            vm.showDetailsView
                ? Provider<LessonDetailsViewModel>.value(
                    value: LessonDetailsViewModel(
                      lessonRepository: context.read<LessonRepository>(),
                      lesson: vm.selected!,
                    ),
                    child: LessonDetailsView(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
