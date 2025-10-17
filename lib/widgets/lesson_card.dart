import 'package:asvz_autosignup/providers/lesson_card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonCard extends StatelessWidget {
  final bool selected;

  const LessonCard({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 12;

    return Consumer<LessonCardViewModel>(
      builder: (context, vm, _) => GestureDetector(
        onSecondaryTapDown: (details) =>
            vm.showContextMenu(context, details.globalPosition),
        onLongPress: () {
          // Long-press (mobile)
          vm.showContextMenu(context, null);
        },
        child: Card(
          color: selected
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : null,
          elevation: 4,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 80,
              width: 240,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.place, size: iconSize),
                                const SizedBox(width: 4),
                                Text(vm.location),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: iconSize,
                                ),
                                const SizedBox(width: 4),
                                Text(vm.date),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        vm.statusIcon,
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: iconSize),
                            const SizedBox(width: 4),
                            Text(vm.time),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
