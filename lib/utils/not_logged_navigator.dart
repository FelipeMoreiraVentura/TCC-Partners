import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

notLoggedNavigator(BuildContext context, User? user) {
  if (user == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, "/HomeBuyer");
    });
    return const SizedBox.shrink();
  }
}
