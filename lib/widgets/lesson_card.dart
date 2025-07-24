import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'package:intl/intl.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
    final DateFormat timeFormat = DateFormat("HH:mm");
    const double iconSize = 12;
    const double statusIconSize = 24;

    return Card(
      //color: Theme.of(context).colorScheme.secondaryContainer,
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
                      lesson.sportName,
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
                            Text(lesson.facility),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: iconSize),
                            const SizedBox(width: 4),
                            Text(dateFormat.format(lesson.starts)),
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
                    Icon(Icons.star_border, size: statusIconSize),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: iconSize),
                        const SizedBox(width: 4),
                        Text(timeFormat.format(lesson.starts)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // Card(
    //         color: Theme.of(context).colorScheme.secondary,
    //         child: Padding(
    //           padding: const EdgeInsets.all(20.0),
    //           child: Text(
    //             'No lessons yet',
    //             style: Theme.of(context).textTheme.displayMedium!.copyWith(
    //               color: Theme.of(context).colorScheme.onSecondary,
    //             ),
    //           ),
    //         ),
    //       ),
    // return Card(
    //   margin: const EdgeInsets.all(8),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(lesson.title, style: Theme.of(context).textTheme.titleLarge),
    //         const SizedBox(height: 8),
    //         Text(lesson.description),
    //         const SizedBox(height: 4),
    //         Text("Location: ${lesson.location}", style: const TextStyle(fontStyle: FontStyle.italic)),
    //       ],
    //     ),
    //   ),
    // );
  }
}
