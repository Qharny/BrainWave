import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quizapp/screen/home.dart';
import 'package:quizapp/services/quiz.dart';

import 'profile.dart';

class QuizDashboard extends StatefulWidget {
  const QuizDashboard({super.key});

  @override
  State<QuizDashboard> createState() => _QuizDashboardState();
}

class _QuizDashboardState extends State<QuizDashboard> {
  final QuizService _quizService = QuizService();
  
  // Quiz categories data with added colors
  final List<Map<String, dynamic>> quizCategories = [
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': const Color(0xFF64B5F6),  // Blue
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': const Color(0xFFFFB74D),  // Orange
    },
    {
      'name': 'Mathematics',
      'icon': Icons.calculate,
      'color': const Color(0xFF81C784),  // Green
    },
    {
      'name': 'Geography',
      'icon': Icons.public,
      'color': const Color(0xFFBA68C8),  // Purple
    },
  ];

  Future<void> _startQuiz(String category) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );

      final questions = await _quizService.fetchQuestions();
      
      if (!mounted) return;
      
      Navigator.pop(context);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            questions: questions,
            category: category,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading questions: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildCategoryCard(int index) {
    final category = quizCategories[index];
    return Card(
      elevation: 8,
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _startQuiz(category['name']),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category['color'].withOpacity(0.2),
                const Color(0xFF2C2C2C),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'] as IconData,
                size: 48,
                color: category['color'],
              ),
              const SizedBox(height: 12),
              Text(
                category['name'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .scale(
        duration: const Duration(milliseconds: 300),
        delay: Duration(milliseconds: 100 * index),
        curve: Curves.easeOut,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Quiz Categories',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Select a Category',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate()
                .fadeIn(duration: const Duration(milliseconds: 500))
                .slideX(),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: quizCategories.length,
                itemBuilder: (context, index) => _buildCategoryCard(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}