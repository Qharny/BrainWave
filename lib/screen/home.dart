import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question.dart';
import 'package:hive/hive.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String category;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool hasAnswered = false;
  String? selectedAnswer;

  void _checkAnswer(String answer) {
    if (hasAnswered) return;

    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;
      if (answer == widget.questions[currentQuestionIndex].correctAnswer) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          hasAnswered = false;
          selectedAnswer = null;
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final userBox = Hive.box('userBox');
    final currentUser = userBox.get('currentUser');
    int quizzesTaken = currentUser['quizzesTaken'] + 1;
    double newAverageScore = ((currentUser['averageScore'] * (quizzesTaken - 1)) + score) / quizzesTaken;

    userBox.put('currentUser', {
      ...currentUser,
      'quizzesTaken': quizzesTaken,
      'averageScore': newAverageScore,
    });

    // Save quiz result to history
    final historyBox = Hive.box('historyBox');
    final quizResult = {
      'category': widget.category,
      'score': score,
      'totalQuestions': widget.questions.length,
      'date': DateTime.now().toString(),
    };
    List<Map<String, dynamic>> quizHistory = historyBox.get('quizHistory', defaultValue: []);
    quizHistory.add(quizResult);
    historyBox.put('quizHistory', quizHistory);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Text('Your score: $score/${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Return to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.3, end: 0),
            const SizedBox(height: 24),
            ...question.shuffledAnswers.map((answer) {
              final bool isSelected = selectedAnswer == answer;
              final bool showCorrect = hasAnswered && 
                  answer == question.correctAnswer;
              final bool showIncorrect = hasAnswered && 
                  isSelected && answer != question.correctAnswer;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(answer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showCorrect
                        ? Colors.green
                        : showIncorrect
                            ? Colors.red
                            : isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: isSelected || showCorrect || showIncorrect
                          ? Colors.white
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ).animate().fadeIn().slideX();
            }).toList(),
            const Spacer(),
            Text(
              'Score: $score',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
