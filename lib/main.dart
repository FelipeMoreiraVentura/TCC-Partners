import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_partners/device/api.dart';
import 'package:market_partners/firebase_options.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.initialize();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const MyApp());
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  const FadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
    );

    return FadeTransition(opacity: fadeAnimation, child: child);
  }
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
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.linux: FadeTransitionBuilder(),
            TargetPlatform.macOS: FadeTransitionBuilder(),
            TargetPlatform.windows: FadeTransitionBuilder(),
          },
        ),
      ),
    );
  }
}
