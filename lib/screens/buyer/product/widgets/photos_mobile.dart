import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget carousel(List images) {
  List<Container> imagesContainers =
      images.map((img) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
          width: double.infinity,
          child: Image.network(img),
        );
      }).toList();

  return Container(
    margin: EdgeInsets.only(top: 10, bottom: 15),
    child: CarouselSlider(
      items: imagesContainers,
      options: CarouselOptions(
        enlargeCenterPage: true,
        viewportFraction: 0.95,
        enableInfiniteScroll: false,
      ),
    ),
  );
}
