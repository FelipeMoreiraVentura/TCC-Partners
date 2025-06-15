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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
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
                  SizedBox(height: 10),
                  Text("Partners Bot", style: AppText.lg),
                  SizedBox(height: 5),
                  Text(
                    "A IA que ajuda você a encontrar o melhor produto",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "O que é o Partners Bot?",
              style: isMobile ? AppText.titleMedium : AppText.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              "O nome do site é Market Partners. É uma plataforma de compras que conta com o Partners Bot, um assistente virtual inteligente que auxilia os usuários a encontrarem o produto ideal através de imagens e perguntas simples.",
              style: AppText.base,
            ),
            SizedBox(height: 10),
            Text(
              "Com base nos produtos cadastrados, o chatbot interpreta imagens e responde dúvidas sobre os itens, proporcionando uma experiência de compra prática e eficiente.",
              style: AppText.base,
            ),
            SizedBox(height: 10),
            Text(
              "Além disso, o Partners Bot ajuda os vendedores ao sugerir descrições e títulos para os anúncios, com base nas imagens enviadas. Isso facilita a criação de anúncios mais completos e atrativos.",
              style: AppText.base,
            ),
            SizedBox(height: 10),
            Text(
              "A aplicação foi criada pela empresa Parters, que tem como missão implementar soluções de inteligência artificial em áreas que ainda não foram exploradas de forma eficaz, sempre focando em facilitar a vida das pessoas.",
              style: AppText.base,
            ),
          ],
        ),
      ),
    );
  }
}
