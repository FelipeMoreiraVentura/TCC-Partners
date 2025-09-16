import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class TranslationService {
  static final _box = GetStorage();

  static Future<String> getSavedLanguage() async {
    return _box.read('language') ?? 'pt';
  }

  static Future<void> saveLanguage(String lang) async {
    await _box.write('language', lang);
  }

  static Future<void> _saveToCache(String key, String translation) async {
    await _box.write(key, translation);
  }

  static Future<String?> _getFromCache(String key) async {
    return _box.read(key);
  }

  static Future<String> translate(String text) async {
    if (text.isEmpty) return text;

    final targetLang = await getSavedLanguage();

    if (targetLang == 'pt') return text;

    final cacheKey = 'translation_${targetLang}_$text';

    final cachedTranslation = await _getFromCache(cacheKey);
    if (cachedTranslation != null) return cachedTranslation;

    try {
      final encodedText = Uri.encodeComponent(text);
      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=$encodedText&langpair=pt|$targetLang&de=felipemoreiraventura@gmail.com&key=0750fb05c1a296120916',
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      final translatedText = data['responseData']?['translatedText'] ?? text;

      await _saveToCache(cacheKey, translatedText);
      return translatedText;
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
