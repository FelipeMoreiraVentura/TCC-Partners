import 'package:flutter/material.dart';
import 'package:market_partners/widgets/back_appbar.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Entregas em andamento"),
      body: Text("Nenhum produto em rota"),
    );
  }
}
