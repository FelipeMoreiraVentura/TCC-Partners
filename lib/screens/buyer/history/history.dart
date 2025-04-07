import 'package:flutter/material.dart';
import 'package:market_partners/widgets/back_appbar.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Histórico de Compras"),
      body: Center(
        child: Column(
          children: [
            Text("Nenhum Produto foi encontrado"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/HomeBuyer");
              },
              child: Text("Comprar"),
            ),
          ],
        ),
      ),
    );
  }
}
