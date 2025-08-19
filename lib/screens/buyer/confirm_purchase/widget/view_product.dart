import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/card_product.dart';

class ViewProduct extends StatelessWidget {
  final List<ProductModel> products;
  const ViewProduct({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    double width = MediaQuery.of(context).size.width;

    List<CardProduct> cardsProduct =
        products.map((product) {
          return CardProduct(
            product: product,
            height: isMobile ? width : width / 2.8,
            width: isMobile ? width : width / 2.8,
            navigator: false,
          );
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          text: products.length == 1 ? "Produto" : "Produtos",
          style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: isMobile ? width : width / 2,
            child: CarouselSlider(
              items: cardsProduct,
              options: CarouselOptions(
                height: isMobile ? width : width / 2.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
