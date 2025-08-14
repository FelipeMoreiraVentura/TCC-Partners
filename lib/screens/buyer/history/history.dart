import 'package:flutter/material.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/widgets/history_card.dart';
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
  List<PurchaseModel> purchases = [];

  @override
  void initState() {
    super.initState();
    getPurchases();
  }

  getPurchases() async {
    final userId = UserService().getUid() ?? '';
    final data = await PurchaseService().getPurchasesByUser(userId, 'buyer');
    setState(() {
      purchases = data;
      if (purchases.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<HistoryCard> widgetPurchases =
        purchases.map((order) {
          return HistoryCard(purchase: order, isBuyer: true);
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
                  child: Column(
                    children: [
                      Text(
                        "Compras Realizadas",
                        style: AppText.titleInfoMedium,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: widgetPurchases,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
