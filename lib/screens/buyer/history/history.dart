import 'package:flutter/material.dart';
import 'package:market_partners/mock/order_history.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool loading = true;
  List history = [];

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    final data = await getOrderHistory();
    setState(() {
      history = data["orders"]!;
      if (history.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<InkWell> historyContainers = history.map((product) {
      return InkWell(child: Text(product["items"][0]["name"]));
    });

    return Scaffold(
      appBar: backAppbar("Histórico de Compras"),
      body: Center(
        child:
            loading
                ? widgetLoading()
                : history.isEmpty
                ? Column(
                  children: [
                    Text("Nenhum Produto foi encontrado"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/HomeBuyer");
                      },
                      child: Text("Comprar"),
                    ),
                  ],
                )
                : Column(children: [historyContainers.first]),
      ),
    );
  }
}
