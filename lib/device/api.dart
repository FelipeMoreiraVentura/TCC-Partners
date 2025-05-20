import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static String get _baseUrl {
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) {
      throw Exception("API_URL not found in .env file");
    }
    return apiUrl;
  }

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("$_baseUrl$endpoint");
    return await http.get(url);
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("$_baseUrl$endpoint");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }
}
