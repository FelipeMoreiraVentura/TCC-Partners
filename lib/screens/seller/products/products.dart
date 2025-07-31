import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/screens/seller/products/widget/product_card.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<ProductModel> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  loadProducts() async {
    String? sellerUid =
        UserService().getUid(); // Replace with actual seller UID
    final data = await ProductService().getProductsBySeller(sellerUid ?? '');
    setState(() {
      products = data;
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
                child: Column(
                  children:
                      products
                          .map((product) => ProductCard(product: product))
                          .toList(),
                ),
              ),
    );
  }
}
