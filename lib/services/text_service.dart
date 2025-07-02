import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/text_model.dart';

class TextService {
  static const String baseUrl = 'http://192.168.1.4:3000/sana';

  static Future<List<SanaText>> getAllTexts() async {
    final response = await http.get(Uri.parse('$baseUrl/levels/1/fields/lettres/texts'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => SanaText.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load texts');
    }
  }
}
