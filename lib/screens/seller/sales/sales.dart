import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  loadSales() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
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
                child: Center(
                  child: Text("Nenhum produto vendido foi encontrado"),
                ),
              ),
    );
  }
}
