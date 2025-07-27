import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class TotalPrice extends StatelessWidget {
  final List<ProductModel> products;
  final String totalPrice;

  const TotalPrice({
    super.key,
    required this.products,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total a se pagar",
          style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
        ),
        ...products.map((product) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(product.name), Text(product.price.toString())],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Frete:"), Text("R\$5,00")],
        ),
        SizedBox(height: 10),
        Text("Total $totalPrice"),
      ],
    );
  }
}
