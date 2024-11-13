import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/screen/dashboard.dart';
import 'package:quizapp/splash.dart';
import 'package:quizapp/auth/auth.dart';
import 'package:quizapp/theme/theme_notifier.dart';
import 'package:quizapp/theme/text_size_notifier.dart';
import 'package:quizapp/theme/sound_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => TextSizeNotifier()),
        ChangeNotifierProvider(create: (_) => SoundNotifier()),
      ],
      child: const BrainWaveApp(),
    ),
  );
}

class BrainWaveApp extends StatelessWidget {
  const BrainWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final textSizeNotifier = Provider.of<TextSizeNotifier>(context);
    final soundNotifier = Provider.of<SoundNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainWave',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: textSizeNotifier.textSize),
          bodyMedium: TextStyle(fontSize: textSizeNotifier.textSize),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    final userBox = Hive.box('userBox');
    final isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuizDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}