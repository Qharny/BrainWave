class QuizQuestion {
  final String id;
  final String category;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;
  final List<String> tags;
  final String type;
  final String difficulty;
  final bool isNiche;
  List<String> shuffledAnswers = [];

  QuizQuestion({
    required this.id,
    required this.category,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.tags,
    required this.type,
    required this.difficulty,
    required this.isNiche,
  }) {
    shuffledAnswers = [...incorrectAnswers, correctAnswer];
    shuffledAnswers.shuffle();
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      category: json['category'],
      correctAnswer: json['correctAnswer'],
      incorrectAnswers: List<String>.from(json['incorrectAnswers']),
      question: json['question']['text'],
      tags: List<String>.from(json['tags']),
      type: json['type'],
      difficulty: json['difficulty'],
      isNiche: json['isNiche'],
    );
  }
}
