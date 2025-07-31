import 'package:flutter/material.dart';
import 'package:market_partners/screens/seller/home/widget/card.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class HomeSeller extends StatelessWidget {
  const HomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isMobile)
              Image.asset(
                "assets/images/logoStringWhite.png",
                height: 43,
                width: 200,
              ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/HomeBuyer");
              },

              child: Row(
                children: [
                  Icon(Icons.business, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Comprar com CNPJ",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
