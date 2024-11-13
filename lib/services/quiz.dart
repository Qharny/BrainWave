import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizService {
  static const String baseUrl = 'https://the-trivia-api.com/v2/questions';

  Future<List<QuizQuestion>> fetchQuestions({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=$limit'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => QuizQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}