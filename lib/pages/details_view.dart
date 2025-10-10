import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatelessWidget {
  final Lesson? lesson;

  const DetailsView({super.key, required this.lesson});

  void onChangeManagedPressed(BuildContext context, Lesson lesson) {
    if (lesson.managed) {
      context.read<LessonProvider>().removeFromManaged(lesson);
    } else {
      context.read<LessonProvider>().addToManaged(lesson);
    }
  }

  void onRemovePressed(BuildContext context, Lesson lesson) {
    context.read<LessonProvider>().removeLesson(lesson);
    print("Pressed the button...");
  }

  void onDebugPressed() {
    print("Pressed the button...");
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
    final DateFormat timeFormat = DateFormat("HH:mm");
    const double iconSize = 24;
    //const double statusIconSize = 24;

    if (lesson == null) return SizedBox.shrink();

    return Container(
      width: 360,
      padding: const EdgeInsets.only(left: 24, right: 12, top: 36),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              lesson!.sportName,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Center(
            child: Text(
              lesson!.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              lesson!.status.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: iconSize),
              const SizedBox(width: 8),
              Text(
                "${dateFormat.format(lesson!.starts)}\n${timeFormat.format(lesson!.starts)} - ${timeFormat.format(lesson!.ends)}",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place, size: iconSize),
              const SizedBox(width: 8),
              Text("${lesson!.facility}\n${lesson!.room}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: iconSize),
              const SizedBox(width: 8),
              Text(lesson!.instructors.join(", ")),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.link, size: iconSize),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(lesson!.link);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      print('Could not launch $url');
                    }
                  },
                  child: Text(
                    lesson!.link,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row(
          //   children: [
          //     const Icon(Icons.event_repeat, size: iconSize),
          //     const SizedBox(width: 8),
          //     MouseRegion(
          //       cursor: SystemMouseCursors.click,
          //       child: GestureDetector(
          //         onTap: () async {
          //           final url = Uri.parse(lesson!.link);
          //           if (await canLaunchUrl(url)) {
          //             await launchUrl(
          //               url,
          //               mode: LaunchMode.externalApplication,
          //             );
          //           } else {
          //             print('Could not launch $url');
          //           }
          //         },
          //         child: Text(
          //           lesson!.link,
          //           style: TextStyle(
          //             color: Colors.blue,
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 30),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => onChangeManagedPressed(context, lesson!),
                    child: lesson!.managed
                        ? Text("Remove from managed")
                        : Text("Add to managed"),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => onRemovePressed(context, lesson!),
                    child: Text("Remove"),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onDebugPressed,
                    child: Text("Debug btton"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
