import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/widgets/card_product.dart';

class ProductCarousel extends StatelessWidget {
  final List<CardProduct> cardProducts;

  const ProductCarousel({super.key, required this.cardProducts});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    double width = MediaQuery.of(context).size.width;

    final CarouselSliderController controller = CarouselSliderController();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isMobile)
          IconButton(
            onPressed: () => controller.previousPage(),
            icon: Icon(Icons.arrow_back_ios),
          ),
        Expanded(
          child: CarouselSlider(
            items: cardProducts,
            carouselController: controller,
            options: CarouselOptions(
              height: isMobile ? 150 : 200,
              enableInfiniteScroll: false,
              viewportFraction: isMobile ? 180 / width : 300 / width,
              padEnds: false,
            ),
          ),
        ),
        if (!isMobile)
          IconButton(
            onPressed: () => controller.nextPage(),
            icon: Icon(Icons.arrow_forward_ios),
          ),
      ],
    );
  }
}
