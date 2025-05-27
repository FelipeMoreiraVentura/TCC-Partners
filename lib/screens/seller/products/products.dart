import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  loadProducts() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Produtos"),
      backgroundColor: AppColors.background,
      body:
          loading
              ? Center(child: widgetLoading())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Nenhum produto encontrado")),
              ),
    );
  }
}
