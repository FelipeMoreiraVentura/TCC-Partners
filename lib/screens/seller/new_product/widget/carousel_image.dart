import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class CarouselImage extends StatelessWidget {
  final List<Uint8List> images;

  const CarouselImage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Center(child: Icon(Icons.image, color: AppColors.blue, size: 200));
    }

    List<Widget> imageView =
        images.map((image) {
          return Image.memory(image, fit: BoxFit.cover);
        }).toList();

    return CarouselSlider(
      items: imageView,
      options: CarouselOptions(
        height: 200,
        enableInfiniteScroll: false,
        viewportFraction: 1.0,
        padEnds: false,
      ),
    );
  }
}
