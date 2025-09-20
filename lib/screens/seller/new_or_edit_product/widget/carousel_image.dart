import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class CarouselImage extends StatelessWidget {
  final List<Column> images;

  const CarouselImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    if (images.isEmpty) {
      return Center(child: Icon(Icons.image, color: AppColors.blue, size: 200));
    }

    return images.isEmpty
        ? Icon(Icons.image, size: 200, color: AppColors.blue)
        : images.length == 1
        ? Center(child: images[0])
        : CarouselSlider(
          items: images,
          options: CarouselOptions(
            height: 200,
            enableInfiniteScroll: false,
            viewportFraction: isMobile ? 1.0 : 0.2,
            padEnds: false,
          ),
        );
  }
}
