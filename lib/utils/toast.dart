import 'package:flutter/material.dart';
import 'package:market_partners/router/app_router.dart';

class ToastService {
  static void show(String message, {Color? backgroundColor}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black87,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void success(String message) =>
      show(message, backgroundColor: Colors.green);

  static void error(String message) =>
      show(message, backgroundColor: Colors.red);
}
