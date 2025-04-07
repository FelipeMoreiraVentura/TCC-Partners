import 'package:flutter/material.dart';
import 'package:market_partners/widgets/back_appbar.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Carrinho"),
      body: Center(child: Text("Nenhum produto salvo no carrinho")),
    );
  }
}
