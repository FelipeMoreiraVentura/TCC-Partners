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
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              CardSeller(
                label: "Anunciar",
                icon: Icon(
                  Icons.shopping_bag_sharp,
                  size: 150,
                  color: AppColors.blue,
                ),
                routeName: "/newProduct",
              ),
              CardSeller(
                label: "Produtos",
                icon: Icon(Icons.storefront, size: 150, color: AppColors.blue),
                routeName: "/products",
              ),
              CardSeller(
                label: "Vendas",
                icon: Icon(Icons.sell, size: 150, color: AppColors.blue),
                routeName: "/sales",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
