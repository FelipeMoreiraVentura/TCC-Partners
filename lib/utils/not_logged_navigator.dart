import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_partners/router/app_router.dart';

notLoggedNavigator(BuildContext context, User? user) {
  if (user == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(AppRoute.homeBuyer);
    });
    return const SizedBox.shrink();
  }
}
