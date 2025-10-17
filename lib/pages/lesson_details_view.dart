import 'package:asvz_autosignup/providers/lesson_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonDetailsView extends StatelessWidget {
  const LessonDetailsView({super.key});

  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonDetailsViewModel>(
      builder: (context, vm, child) => Container(
        width: 360,
        padding: const EdgeInsets.only(left: 24, right: 12, top: 36),
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                vm.title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Center(
              child: Text(
                vm.subtitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                vm.status,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: iconSize),
                const SizedBox(width: 8),
                Text(vm.time),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place, size: iconSize),
                const SizedBox(width: 8),
                Text(vm.location),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: iconSize),
                const SizedBox(width: 8),
                Text(vm.instructors),
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
                      if (await canLaunchUrl(vm.uri)) {
                        await launchUrl(
                          vm.uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print('Could not launch ${vm.link}');
                      }
                    },
                    child: Text(
                      vm.link,
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
            const SizedBox(height: 30),
            Center(
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: vm.onChangeManagedPressed,
                      child: Text(vm.changeManagedText),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: vm.onRemovePressed,
                      child: Text(vm.removeText),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: vm.onOptionPressed,
                      child: Text(vm.optionText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
