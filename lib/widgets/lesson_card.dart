import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  void _showContextMenu(BuildContext context, Offset? position) async {
    final lessonProvider = context.read<LessonProvider>();
    final result = await showMenu(
      context: context,
      position: position != null
          ? RelativeRect.fromLTRB(
              position.dx,
              position.dy,
              position.dx,
              position.dy,
            )
          : const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [!lesson.managed ? const PopupMenuItem(value: 'addToManaged', child: Text('Add to Managed')) : const PopupMenuItem(value: 'removeFromManaged', child: Text('Remove from Managed')), const PopupMenuItem(value: 'delete', child: Text('Delete'))],
    );

    switch (result) {
      case 'delete':
        lessonProvider.removeLesson(lesson);
      case 'addToManaged':
        lessonProvider.addToManaged(lesson);
      case 'removeFromManaged':
        lessonProvider.removeFromManaged(lesson);
      case null:
        break;
      default:
        throw UnimplementedError('no action for $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
    final DateFormat timeFormat = DateFormat("HH:mm");
    const double iconSize = 12;
    const double statusIconSize = 24;

    return GestureDetector(
      onSecondaryTapDown: (details) =>
          _showContextMenu(context, details.globalPosition),
      onLongPress: () {
        // Long-press (mobile)
        _showContextMenu(context, null);
      },
      child: Card(
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
      ),
    );
  }
}
