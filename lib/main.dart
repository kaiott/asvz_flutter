import 'package:asvz_autosignup/pages/schedule_view.dart';
import 'package:asvz_autosignup/pages/schedule_view2.dart';
import 'package:asvz_autosignup/pages/token_view.dart';
import 'package:asvz_autosignup/providers/lesson_provider.dart';
import 'package:asvz_autosignup/providers/schedule_view_model.dart';
import 'package:asvz_autosignup/providers/token_view_model.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:asvz_autosignup/services/lesson_agent_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import './models/lesson.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DataBase stuff
  await Hive.initFlutter();
  Hive.registerAdapter(LessonAdapter());
  //await Hive.deleteBoxFromDisk('lessons');
  await Hive.openBox<Lesson>('lessons');

  // Initialize services, repos etc
  final tokenRepository = TokenRepository();
  final lessonAgentManager = LessonAgentManager();
  final lessonRepository = LessonRepository(tokenRepository: tokenRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenRepository>(
          create: (_) => tokenRepository,
        ), // such that lower level UI elements have access if needed
        Provider<LessonAgentManager>(create: (_) => lessonAgentManager),

        ChangeNotifierProvider<LessonRepository>(create: (context) => lessonRepository),
        ChangeNotifierProvider<LessonProvider>(
          create: (context) => LessonProvider(),
        ),
        ChangeNotifierProvider<TokenViewModel>(
          create: (context) => TokenViewModel(tokenRepository: tokenRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<LessonAgentManager>(
      context,
      listen: false,
    ).injectProvider(context.read<LessonProvider>());
    return MaterialApp(
      title: 'ASVZ Auto Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = UpcomingPage();
      case 1:
        page = PastPage();
      case 2:
        //page = InterestedPage();
        page = ChangeNotifierProvider<ScheduleViewModel>(
          create: (context) => ScheduleViewModel(
            lessonRepository: context.read<LessonRepository>(),
          ),
          child: ScheduleView2(),
        );
      case 3:
        page = TokenView();
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
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow,
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
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class InterestedPage extends StatelessWidget {
//   const InterestedPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     //final LessonProvider lessonProvider = LessonProvider();
//     List<Lesson> lessons = context.watch<LessonProvider>().getLessons();
//     final children = [
//       for (final lesson in lessons) LessonCard(lesson: lesson),
//     ];
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: children,
//       ),
//     );
//   }
// }
