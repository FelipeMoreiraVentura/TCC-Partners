import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class PartnersBot extends StatelessWidget {
  const PartnersBot({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Partners Bot", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/chatIcon.png",
                  height: 200,
                  width: 200,
                ),
                Text("Partners Bot", style: AppText.lg),
                Text("A IA que ajuda você a encontrar o melhor produto"),
              ],
            ),
          ),

          SizedBox(height: 30),
          Text(
            "O que é o Partners Bot?",
            style: isMobile ? AppText.titleMedium : AppText.titleLarge,
          ),
        ],
      ),
    );
  }
}
