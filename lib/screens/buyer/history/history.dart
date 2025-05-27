import 'package:flutter/material.dart';
import 'package:market_partners/mock/order_history.dart';
import 'package:market_partners/screens/buyer/history/widget/history_card.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';

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
    List<HistoryCard> widgetHistoryDelivered =
        history.where((order) => order["status"] == "Delivered").map((order) {
          return HistoryCard(history: order);
        }).toList();

    List<HistoryCard> widgetHistoryShipped =
        history.where((order) => order["status"] == "Shipped").map((order) {
          return HistoryCard(history: order);
        }).toList();

    return Scaffold(
      appBar: backAppbar("Histórico de Compras"),
      backgroundColor: AppColors.background,
      body: NavBar(
        child:
            loading
                ? Center(child: widgetLoading())
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Text("Compras Entregues", style: AppText.titleInfoMedium),
                      ...widgetHistoryDelivered,
                      Text("Compras Enviadas", style: AppText.titleInfoMedium),
                      ...widgetHistoryShipped,
                    ],
                  ),
                ),
      ),
    );
  }
}
