import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

Widget carousel(bool isMobile, sizeScreen) {
  List<Widget> items = [
    Container(
      height: sizeScreen.height * 0.6,
      width: sizeScreen.width * 0.9,
      decoration: BoxDecoration(
        color: AppColors.grey_100,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(
            "Precisa de ajuda nas compras?",
            style: isMobile ? AppText.titleTiny : AppText.titleLarge,
          ),
          Image.asset(
            "assets/images/chatIcon.png",
            height: isMobile ? 100 : 200,
            width: isMobile ? 100 : 200,
          ),
          Text(
            "Converse com o PartnersBot !",
            style: isMobile ? AppText.tiny : AppText.medium,
          ),
        ],
      ),
    ),
  ];

  return CarouselSlider(items: items, options: CarouselOptions(autoPlay: true));
}
