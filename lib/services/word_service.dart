import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_model.dart';

class WordService {
  static const String baseUrl = 'https://sana-dictionary-api.onrender.com/sana';

  static Future<List<SanaWord>> getTextWords(int textId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/levels/1/fields/lettres/texts/$textId/words'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => SanaWord.fromJson(json)).toList(); // ✅ Not SanaText
    } else {
      throw Exception('Failed to load words');
    }
  }
}
