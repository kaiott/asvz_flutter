import 'package:asvz_autosignup/pages/lesson_details_view.dart';
import 'package:asvz_autosignup/providers/lesson_card_view_model.dart';
import 'package:asvz_autosignup/providers/lesson_details_view_model.dart';
import 'package:asvz_autosignup/providers/schedule_view_model.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/widgets/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

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
                                child: Provider<LessonCardViewModel>.value(
                                  value: LessonCardViewModel(
                                    lessonRepository: context
                                        .read<LessonRepository>(),
                                    lesson: lesson,
                                  ),
                                  child: LessonCard(
                                    selected: lesson == vm.selected,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => vm.onFABClicked(context),
                  tooltip: vm.fabTooptip,
                  child: vm.fabIcon,
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
