import 'package:flutter/material.dart';
import 'package:market_partners/screens/buyer/product/widgets/photos_desktop.dart';
import 'package:market_partners/screens/buyer/product/widgets/photos_mobile.dart';
import 'package:market_partners/screens/buyer/product/widgets/stars_rating.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';

class ProductInfo extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductInfo({super.key, required this.product});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    Map<String, dynamic> product = widget.product;

    Text productName = Text(
      product["name"],
      style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
    );

    Text price = Text(
      "R\$ ${product["price"].toString()}",
      style: isMobile ? AppText.lg : AppText.xl,
      softWrap: true,
    );

    StarRating rate = StarRating(rating: product["rating"]);

    Text description = Text(
      product["description"],
      style: AppText.sm.merge(AppText.description),
      softWrap: true,
    );

    Column action = Column(
      children: [
        MyOutlinedButton(
          onPressed: () {},
          child: Text(
            "Adicionar ao Carrinho",
            style: TextStyle(color: AppColors.blue),
          ),
        ),
        SizedBox(height: 10),
        MyFilledButton(
          onPressed: () {},
          child: Text("Comprar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );

    return isMobile
        ? Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productName,
              carousel(product["images"]),
              rate,
              price,
              description,
              action,
            ],
          ),
        )
        : Container(
          margin: const EdgeInsets.all(5),
          height: 500,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Photosdesktop(images: product["images"]),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [productName, rate, price, description],
                      ),
                      action,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
