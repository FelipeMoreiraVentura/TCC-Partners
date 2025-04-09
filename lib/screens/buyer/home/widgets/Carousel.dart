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
            "PRECISA DE AJUDA NAS COMPRAS?",
            style: isMobile ? AppText.titleTiny : AppText.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Image.asset(
            "assets/images/chatIcon.png",
            height: isMobile ? 80 : 180,
            width: isMobile ? 80 : 180,
          ),
          const SizedBox(height: 16),
          Text(
            "CONVERSE COM O PARTNERSBOT!",
            style: isMobile ? AppText.sm : AppText.lg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),

    Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen[200],
        borderRadius: BorderRadius.circular(32),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "APROVEITE OFERTAS EXCLUSIVAS!",
            style: isMobile ? AppText.titleTiny : AppText.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.local_offer,
            size: isMobile ? 60 : 120,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            "Veja os melhores preços da semana",
            style: isMobile ? AppText.sm : AppText.lg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),

    Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[100],
        borderRadius: BorderRadius.circular(32),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "VENDA COM AJUDA DO PARTNERSBOT!",
            style: isMobile ? AppText.titleTiny : AppText.titleLarge,
            textAlign: TextAlign.center,
          ),
          Image.asset(
            "assets/images/chatIcon.png", // imagem ilustrativa de IA/vendas
            height: isMobile ? 60 : 130,
            width: isMobile ? 60 : 130,
          ),
          const SizedBox(height: 16),
          Text(
            "Envie uma foto e a IA preenche o anúncio pra você!",
            style: isMobile ? AppText.sm : AppText.lg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Seja um parceiro vendedor agora mesmo.",
            style: isMobile ? AppText.sm : AppText.md,
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
        viewportFraction: 0.95,
      ),
    ),
  );
}
