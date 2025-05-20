import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class CardProduct extends StatelessWidget {
  final Map<String, dynamic> product;

  const CardProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/product");
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 5 : 10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColors.menu,
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
          ],
        ),
        height: isMobile ? 150 : 200,
        width: isMobile ? 150 : 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              product["images"][0],
              height: isMobile ? 60 : 90,
              width: isMobile ? 60 : 90,
            ),
            Text(product["name"], style: isMobile ? AppText.xs : AppText.sm),
            Text(product["price"].toString(), style: AppText.md),
          ],
        ),
      ),
    );
  }
}
