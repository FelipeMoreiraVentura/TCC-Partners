import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TranslationService {
  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'pt';
  }

  static Future<String> translate(String text) async {
    if (text.isEmpty) return text;
    final apiUrl = dotenv.env['TRANSLATE_API']!;

    try {
      final lang = await getSavedLanguage();
      final encodedText = Uri.encodeComponent(text);
      final url = Uri.parse('$apiUrl$lang&q=$encodedText');

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      return (data is List && data.isNotEmpty && data[0] is List)
          ? data[0][0] ?? text
          : text;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text;
    }
  }
}

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TranslatedText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TranslationService.translate(text),
      builder: (context, snapshot) {
        return Text(snapshot.hasData ? snapshot.data! : text, style: style);
      },
    );
  }
}
