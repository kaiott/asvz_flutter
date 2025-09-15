import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsView extends StatelessWidget {
  final Lesson? lesson;

  const DetailsView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("EEE dd.MM.yyyy");
    final DateFormat timeFormat = DateFormat("HH:mm");
    const double iconSize = 18;
    const double statusIconSize = 24;

    if (lesson == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(lesson!.sportName),
          Text(lesson!.status.name),
          Row(
                children: [
                  const Icon(Icons.calendar_today, size: iconSize),
                  const SizedBox(width: 4),
                  Text("${dateFormat.format(lesson!.starts)}\n${timeFormat.format(lesson!.starts)}"),
                ],
              ),
              Row(
            children: [
              const Icon(Icons.place, size: iconSize),
              const SizedBox(width: 4),
              Text("${lesson!.facility}\n${lesson!.room}"),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.person, size: iconSize),
              const SizedBox(width: 4),
              Text(lesson!.instructors[0]),
            ],
          ),
        ],
        
      ),
    );
  }
}
