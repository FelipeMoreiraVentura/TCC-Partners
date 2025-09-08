import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TranslationService {
  static Future<String> getSavedLanguage() async {
    if (kIsWeb) {
      return html.window.localStorage['language'] ?? 'pt';
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('language') ?? 'pt';
    }
  }

  static Future<void> _saveToCache(String key, String translation) async {
    final encodedKey = Uri.encodeComponent(key);
    final encodedValue = Uri.encodeComponent(translation);

    if (kIsWeb) {
      html.document.cookie = '$encodedKey=$encodedValue';
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, translation);
    }
  }

  static Future<String?> _getFromCache(String key) async {
    final encodedKey = Uri.encodeComponent(key);

    if (kIsWeb) {
      final cookies = html.document.cookie?.split('; ') ?? [];
      for (final cookie in cookies) {
        final split = cookie.split('=');
        if (split.length == 2 && split[0] == encodedKey) {
          return Uri.decodeComponent(split[1]);
        }
      }
      return null;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  static Future<String> translate(String text) async {
    if (text.isEmpty) return text;

    final targetLang = await getSavedLanguage();

    // Não traduz se o destino for 'pt'
    if (targetLang == 'pt') return text;

    final cacheKey = 'translation_${targetLang}_$text';

    final cachedTranslation = await _getFromCache(cacheKey);
    if (cachedTranslation != null) return cachedTranslation;

    try {
      final encodedText = Uri.encodeComponent(text);
      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=$encodedText&langpair=pt|$targetLang&de=felipemoreiraventura@gmail.com&key=MYKEY',
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
