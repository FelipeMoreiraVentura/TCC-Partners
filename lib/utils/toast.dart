// utils/toast_service.dart
import 'package:flutter/material.dart';
import '../main.dart'; // importa a navigatorKey

class ToastService {
  static void show(String message, {Color? backgroundColor}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black87,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void success(String message) {
    show(message, backgroundColor: Colors.green);
  }

  static void error(String message) {
    show(message, backgroundColor: Colors.red);
  }
}
