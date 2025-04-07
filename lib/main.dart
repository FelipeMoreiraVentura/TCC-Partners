import 'package:flutter/material.dart';
import 'package:market_partners/screens/buyer/cart/cart.dart';
import 'package:market_partners/screens/buyer/configurations/confing.dart';
import 'package:market_partners/screens/buyer/delivery/delivery.dart';
import 'package:market_partners/screens/buyer/history/history.dart';
import 'package:market_partners/screens/buyer/partnersBot/partners_bot.dart';
import "screens/login/login.dart";
import 'screens/buyer/home/home.dart';

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
      initialRoute: "/HomeBuyer",
      routes: {
        "/login": (context) => const Login(),
        //Buyer routes
        "/HomeBuyer": (context) => const HomeBuyer(),
        "/configuration": (context) => const Confing(),
        "/configuration/PartnersBot": (context) => const PartnersBot(),
        "/history": (context) => const History(),
        "/delivery": (context) => const Delivery(),
        "/cart": (context) => const Cart(),
      },
    );
  }
}
