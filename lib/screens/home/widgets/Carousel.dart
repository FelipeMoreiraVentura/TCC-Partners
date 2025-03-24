import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

Widget carousel(bool isMobile, Size sizeScreen) {
  List<Widget> items = [
    Container(
      decoration: BoxDecoration(
        color: Colors.amberAccent[200],
        borderRadius: BorderRadius.circular(32),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Precisa de ajuda nas compras?",
            style: isMobile ? AppText.titleTiny : AppText.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Image.asset(
            "assets/images/chatIcon.png",
            height: isMobile ? 80 : 200,
            width: isMobile ? 80 : 200,
          ),
          const SizedBox(height: 16),
          Text(
            "Converse com o PartnersBot!",
            style: isMobile ? AppText.sm : AppText.lg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ];

  return Container(
    margin: EdgeInsets.only(top: 10, bottom: 15),
    child: CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: isMobile ? 200 : 400,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.95, // permite mostrar uma margem lateral
      ),
    ),
  );
}
