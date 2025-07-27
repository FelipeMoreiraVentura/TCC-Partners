import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PhotosMobile extends StatelessWidget {
  final List images;
  const PhotosMobile({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Container> imagesContainers =
        images.map((img) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.memory(base64Decode(img), width: width, height: width),
          );
        }).toList();

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 15),
      child: CarouselSlider(
        items: imagesContainers,
        options: CarouselOptions(
          height: width,
          enlargeCenterPage: true,
          viewportFraction: 0.95,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }
}
