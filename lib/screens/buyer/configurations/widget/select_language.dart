import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  // Idiomas compatíveis com a API MyMemory
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

  String? _language;

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('language');
    setState(() {
      _language = cached ?? 'pt';
    });
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  @override
  Widget build(BuildContext context) {
    return Popup(
      title: "Linguagem",
      child: Column(
        children:
            supportedLanguages.entries.map((entry) {
              return TextButton(
                onPressed: () async {
                  await setLanguage(entry.key);
                  // ignore: use_build_context_synchronously
                  context.pushNamed(AppRoute.configuration);
                },
                child: Row(
                  children: [
                    if (_language == entry.key)
                      const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(entry.value),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
