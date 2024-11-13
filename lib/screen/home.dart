import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../theme/sound_notifier.dart';

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
        if (Provider.of<SoundNotifier>(context, listen: false).isSoundEnabled) {
          // Play sound for correct answer
        }
      } else {
        if (Provider.of<SoundNotifier>(context, listen: false).isSoundEnabled) {
          // Play sound for incorrect answer
        }
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
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Quiz Complete!',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              score > (widget.questions.length / 2)
                  ? Icons.emoji_events
                  : Icons.stars,
              size: 64,
              color: score > (widget.questions.length / 2)
                  ? Colors.amber
                  : Colors.blue,
            ).animate().scale(),
            const SizedBox(height: 16),
            Text(
              'Your score: $score/${widget.questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        title: Text(
          widget.category,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / widget.questions.length,
                backgroundColor: Colors.grey[800],
                color: Colors.blue,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 20),
              Text(
                'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 8,
                color: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      height: 1.4,
                    ),
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
                    onPressed: hasAnswered ? null : () => _checkAnswer(answer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCorrect
                          ? Colors.green.withOpacity(0.8)
                          : showIncorrect
                              ? Colors.red.withOpacity(0.8)
                              : isSelected
                                  ? Theme.of(context).primaryColor
                                  : const Color(0xFF2C2C2C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: showCorrect || showIncorrect || isSelected
                              ? Colors.transparent
                              : Colors.grey[700]!,
                          width: 1,
                        ),
                      ),
                      elevation: showCorrect || showIncorrect || isSelected ? 8 : 2,
                    ),
                    child: Text(
                      answer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ).animate().fadeIn().slideX();
              }),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Score: $score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}