import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final Map<String, String> supportedLanguages = const {
    'pt': 'Português',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'nl': 'Nederlands',
    'zh': '中文 (Chinês Simplificado)',
    'ja': '日本語 (Japonês)',
    'ko': '한국어 (Coreano)',
    'ru': 'Русский (Russo)',
    'ar': 'العربية (Árabe)',
    'hi': 'हिन्दी (Hindi)',
    'tr': 'Türkçe (Turco)',
    'vi': 'Tiếng Việt',
    'th': 'ไทย (Tailandês)',
  };

  String _language = 'pt';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    String? cachedLang;

    if (kIsWeb) {
      cachedLang = html.window.localStorage['language'];
    } else {
      final prefs = await SharedPreferences.getInstance();
      cachedLang = prefs.getString('language');
    }

    setState(() {
      _language =
          supportedLanguages.keys.contains(cachedLang) ? cachedLang! : 'pt';
    });
  }

  Future<void> _setLanguage(String lang) async {
    if (kIsWeb) {
      html.window.localStorage['language'] = lang;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', lang);
    }

    setState(() {
      _language = lang;
    });

    // ignore: use_build_context_synchronously
    context.pushNamed(AppRoute.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Popup(
      title: "Linguagem",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            supportedLanguages.entries.map((entry) {
              final isSelected = _language == entry.key;
              return TextButton(
                onPressed: () => _setLanguage(entry.key),
                child: Row(
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.green),
                    if (isSelected) const SizedBox(width: 8),
                    Text(entry.value),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
