import 'package:asvz_autosignup/pages/login_view.dart';
import 'package:asvz_autosignup/pages/schedule_view.dart';
import 'package:asvz_autosignup/pages/token_view.dart';
import 'package:asvz_autosignup/providers/schedule_view_model.dart';
import 'package:asvz_autosignup/providers/token_view_model.dart';
import 'package:asvz_autosignup/repositories/credentials_repository.dart';
import 'package:asvz_autosignup/repositories/lesson_repository.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:asvz_autosignup/services/lesson_database_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import './models/lesson.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive stuff (for HiveLessonDatabaseService implementation of LessonDatabaseService)
  await Hive.initFlutter();
  Hive.registerAdapter(LessonAdapter());
  await Hive.openBox<Lesson>('lessons');

  // Initialize services, repos etc
  final LessonDatabaseService lessonDatabaseService =
      await HiveLessonDatabaseService.create();
  final credentialsRepository = CredentialsRepository();
  await credentialsRepository.checkCredentials();
  if (credentialsRepository.status == CredentialStatus.none) {
    // if not logged in clear database
    // this is only safeguard, because on log out all lessons are removed too.
    lessonDatabaseService.clear();
  }
  final tokenRepository = TokenRepository(
    credentialsRepository: credentialsRepository,
  );
  final lessonRepository = LessonRepository(
    tokenRepository: tokenRepository,
    lessonDatabaseService: lessonDatabaseService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CredentialsRepository>(
          create: (context) => credentialsRepository,
        ),
        Provider<TokenRepository>(create: (context) => tokenRepository),
        ChangeNotifierProvider<LessonRepository>(
          create: (context) => lessonRepository,
        ),
        ChangeNotifierProvider<TokenViewModel>(
          create: (context) => TokenViewModel(
            lessonRepository: lessonRepository,
            tokenRepository: tokenRepository,
            credentialsRepository: credentialsRepository,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    CredentialsRepository credentialsRepository = context
        .watch<CredentialsRepository>();
    return credentialsRepository.status == CredentialStatus.none
        ? LoginView(credentialsRepository: credentialsRepository, failed: false)
        : credentialsRepository.status == CredentialStatus.invalid
        ? LoginView(credentialsRepository: credentialsRepository, failed: true)
        : const MyHomePage();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASVZ Auto Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const Root(),
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
        page = ChangeNotifierProvider<ScheduleViewModel>(
          key: ValueKey(selectedIndex),
          create: (context) => FutureScheduleViewModel(
            lessonRepository: context.read<LessonRepository>(),
          ),
          child: ScheduleView(),
        );
      case 1:
        page = ChangeNotifierProvider<ScheduleViewModel>(
          key: ValueKey(selectedIndex),
          create: (context) => ManagedScheduleViewModel(
            lessonRepository: context.read<LessonRepository>(),
          ),
          child: ScheduleView(),
        );
      case 2:
        page = ChangeNotifierProvider<ScheduleViewModel>(
          key: ValueKey(selectedIndex),
          create: (context) => PastScheduleViewModel(
            lessonRepository: context.read<LessonRepository>(),
          ),
          child: ScheduleView(),
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
                      icon: Icon(Icons.favorite),
                      label: Text('Interested'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.arrow_circle_right),
                      label: Text('Managed'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.arrow_circle_left_outlined),
                      label: Text('Past'),
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
