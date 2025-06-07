import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class WrapProduct extends StatelessWidget {
  final List<Map<String, Object>> products;
  const WrapProduct({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    List<Widget> productView =
        products.take(16).map((product) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/product/${product["id"]}");
            },
            child: Container(
              padding: EdgeInsets.all(isMobile ? 5 : 10),
              height: isMobile ? 180 : 210,
              width: isMobile ? 180 : 210,
              color: AppColors.menu,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    (product["images"] as List)[0],
                    height: isMobile ? 70 : 100,
                    width: isMobile ? 70 : 100,
                  ),
                  Text(
                    product["name"].toString(),
                    style: isMobile ? AppText.xs : AppText.base,
                  ),
                  Text(product["price"].toString(), style: AppText.md),
                ],
              ),
            ),
          );
        }).toList();

    return Container(
      margin: isMobile ? null : EdgeInsets.only(left: 5, right: 5),
      child: Wrap(spacing: 2, runSpacing: 2, children: productView),
    );
  }
}
