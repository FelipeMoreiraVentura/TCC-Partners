import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class CardProduct extends StatelessWidget {
  final Map<String, dynamic> product;
  final double width;
  final double height;
  final bool navigator;

  const CardProduct({
    super.key,
    required this.product,
    this.width = 0,
    this.height = 0,
    this.navigator = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return InkWell(
      onTap:
          navigator
              ? () {
                Navigator.pushNamed(context, "/product/${product["id"]}");
              }
              : () {},
      child: Container(
        padding: EdgeInsets.all(isMobile ? 5 : 10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.menu,
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
          ],
        ),
        height:
            height != 0
                ? height
                : isMobile
                ? 150
                : 200,
        width:
            width != 0
                ? width
                : isMobile
                ? 150
                : 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
              product["images"][0],
              height:
                  height != 0
                      ? height / 1.8
                      : isMobile
                      ? 60
                      : 90,
              width:
                  width != 0
                      ? width / 1.8
                      : isMobile
                      ? 60.0
                      : 90.0,
            ),
            Column(
              children: [
                Text(
                  product["name"],
                  style: isMobile ? AppText.xs : AppText.sm,
                ),
                Text(product["price"].toString(), style: AppText.md),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
