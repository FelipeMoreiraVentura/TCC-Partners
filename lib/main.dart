import 'package:flutter/material.dart';
import "screens/login/login.dart";
import 'screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Market Partners",
      initialRoute: "/",
      routes: {
        "/login": (context) => const Login(),
        "/": (context) => const Home(),
      },
    );
  }
}
