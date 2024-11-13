import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/splash.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const BrainWaveApp());
}

class BrainWaveApp extends StatelessWidget {
  const BrainWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainWave',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const SplashScreen(),
    );
  }
}
