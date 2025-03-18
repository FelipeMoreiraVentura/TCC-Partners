import 'package:flutter/material.dart';
import 'package:market_partners/buildListView.dart';
import 'package:market_partners/buildlistview2.dart';
import 'package:market_partners/screens/corPreferida.dart';
import 'package:market_partners/terceira.dart';
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
        "/cor": (conrext) => CorPreferida(),
        "/list": (context) => buildlistview(),
        "/list2": (context) => Buildlistview2(),
        "/3": (context) => Terceira(),
      },
    );
  }
}
