import 'package:flutter/material.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/history_card.dart';
import 'package:market_partners/widgets/loading.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  bool loading = true;
  List<PurchaseModel> sales = [];

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  loadSales() async {
    final userId = UserService().getUid() ?? '';
    final data = await PurchaseService().getPurchasesByUser(userId, 'seller');
    setState(() {
      sales = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Vendas"),
      backgroundColor: AppColors.background,
      body:
          loading
              ? Center(child: widgetLoading())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    sales.isEmpty
                        ? Center(
                          child: Text("Nenhum produto vendido foi encontrado"),
                        )
                        : Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children:
                              sales.map((order) {
                                return HistoryCard(purchase: order);
                              }).toList(),
                        ),
              ),
    );
  }
}
