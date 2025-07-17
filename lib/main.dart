import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import './models/lesson.dart';
import './widgets/lesson_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASVZ Auto Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedIndex = 0;
  final lessonProvider = LessonProvider();

  void _incrementCounter() {
    setState(() {
      _counter++;
      lessonProvider.addLesson(testLessons[(_counter-1) % testLessons.length]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = UpcomingPage(counter: _counter);
      case 1 || 2 || 3:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.arrow_circle_right),
                      label: Text('Upcoming'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.arrow_circle_left_outlined),
                      label: Text('Past'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Interested'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment),
                      label: Text('Log'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(child: Container(color: Theme.of(context).colorScheme.primaryContainer, child: page)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key, required int counter}) : _counter = counter;

  final int _counter;

  @override
  Widget build(BuildContext context) {
    final LessonProvider lessonProvider = LessonProvider();
    List<Lesson> lessons = lessonProvider.getLessons();
    final children = [
      for (final lesson in lessons) LessonCard(lesson: lesson),
      Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
