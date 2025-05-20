// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/widgets/card_product.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/product_carousel.dart';
import 'package:market_partners/widgets/wrap_product.dart';

class Products extends StatefulWidget {
  final bool isMobile;
  final sizeScreen;

  const Products({super.key, required this.isMobile, required this.sizeScreen});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool loading = true;
  List products = [];

  final CarouselSliderController controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await getProducts();
    setState(() {
      products = data["products"]!;
      if (products.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CardProduct> widgetsProductsMostPurchased =
        products.map((product) {
          return CardProduct(product: product);
        }).toList();

    return Column(
      children: [
        Text("Mais comprados", style: AppText.titleMedium),
        loading
            ? widgetLoading()
            : ProductCarousel(cardProducts: widgetsProductsMostPurchased),
        SizedBox(height: 20),

        Text("Recomendado para você", style: AppText.titleMedium),
        loading
            ? widgetLoading()
            : WrapProduct(products: products.cast<Map<String, Object>>()),
      ],
    );
  }
}
