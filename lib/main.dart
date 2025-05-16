import 'package:flutter/material.dart';
import 'package:market_partners/device/api.dart';
import 'package:market_partners/screens/buyer/cart/cart.dart';
import 'package:market_partners/screens/buyer/configurations/confing.dart';
import 'package:market_partners/screens/buyer/delivery/delivery.dart';
import 'package:market_partners/screens/buyer/history/history.dart';
import 'package:market_partners/screens/buyer/partnersBot/partners_bot.dart';
import 'package:market_partners/screens/buyer/product/product.dart';
import 'package:market_partners/screens/seller/home/home.dart';
import 'package:market_partners/screens/seller/new_product/new_product.dart';
import "screens/login/login.dart";
import 'screens/buyer/home/home.dart';

Future<void> main() async {
  await Api.initialize();
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
        "/product": (context) => const Product(),

        //Seller routes
        "/HomeSeller": (context) => const HomeSeller(),
        "/newProduct": (context) => const NewProduct(),
      },
    );
  }
}
