import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quizapp/screen/home.dart';
import 'package:quizapp/services/quiz.dart';


class QuizDashboard extends StatefulWidget {
  const QuizDashboard({super.key});

  @override
  State<QuizDashboard> createState() => _QuizDashboardState();
}

class _QuizDashboardState extends State<QuizDashboard> {
  final QuizService _quizService = QuizService();
  
  // Quiz categories data
  final List<Map<String, dynamic>> quizCategories = [
    {'name': 'Science', 'icon': Icons.science},
    {'name': 'History', 'icon': Icons.history_edu},
    {'name': 'Mathematics', 'icon': Icons.calculate},
    {'name': 'Geography', 'icon': Icons.public},
  ];

  // Start quiz function
  Future<void> _startQuiz(String category) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Fetch questions from API
      final questions = await _quizService.fetchQuestions();
      
      if (!mounted) return;
      
      // Remove loading indicator
      Navigator.pop(context);
      
      // Navigate to quiz screen
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
      // Handle errors
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading questions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build category card
  Widget _buildCategoryCard(int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _startQuiz(quizCategories[index]['name']),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              quizCategories[index]['icon'] as IconData,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              quizCategories[index]['name'] as String,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
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
      appBar: AppBar(
        title: const Text('Quiz Categories'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add profile or settings navigation here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a Category',
              style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }
}