import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/device/api.dart';
import 'package:market_partners/firebase_options.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  await Api.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Market Partners",
      routerConfig: appRouter,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
