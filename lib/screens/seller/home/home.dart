import 'package:flutter/material.dart';
import 'package:market_partners/screens/seller/home/widget/card.dart';
import 'package:market_partners/utils/style.dart';

class HomeSeller extends StatelessWidget {
  const HomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.blue),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardSeller(
              label: "produtos",
              icon: Icon(Icons.shopping_bag, size: 150, color: AppColors.blue),
              routeName: "/productsSellers",
            ),
            CardSeller(
              label: "",
              icon: Icon(Icons.shopping_bag, size: 150, color: AppColors.blue),
              routeName: "/productsSellers",
            ),
            CardSeller(
              label: "produtos",
              icon: Icon(Icons.shopping_bag, size: 150, color: AppColors.blue),
              routeName: "/productsSellers",
            ),
          ],
        ),
      ),
    );
  }
}
