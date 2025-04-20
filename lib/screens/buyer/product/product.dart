import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/loading.dart';

import 'widgets/photosDesktop.dart';
import 'widgets/photosMobile.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool loading = true;
  Map<String, dynamic> product = {};

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  void loadProduct() async {
    final data = await getProducts();
    setState(() {
      product = data["products"]![0] as Map<String, dynamic>;
      if (product.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    if (loading) {
      return Container(
        color: AppColors.background,
        child: Center(child: widgetLoading()),
      );
    }

    Text productName = Text(
      product["name"],
      style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
    );

    Text price = Text(
      "R\$ ${product["price"].toString()}",
      style: isMobile ? AppText.lg : AppText.xl,
      softWrap: true,
    );

    Row rate = Row(
      children: [
        Icon(Icons.star, size: 15),
        Text(
          "${product["rating"]["average"].toString()} (${product["rating"]["count"].toString()})",
        ),
      ],
    );

    Text description = Text(
      product["description"],
      style: AppText.sm.merge(AppText.description),
    );

    return Scaffold(
      appBar: infoAppbar(isMobile, context),
      body: SingleChildScrollView(
        child:
            isMobile
                ? Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productName,
                      carousel(product["images"]),
                      rate,
                      price,
                      description,
                    ],
                  ),
                )
                : Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Photosdesktop(images: product["images"]),
                      Container(
                        margin: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [productName, rate, price, description],
                        ),
                      ),
                    ],
                  ),
                ), // Add a fallback widget for non-mobile
      ),
    );
  }
}
