import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';

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
        const Icon(Icons.star, size: 15),
        Text(
          "${product["rating"]["average"].toString()} (${product["rating"]["count"].toString()})",
        ),
      ],
    );

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

    return Scaffold(
      appBar: infoAppbar(isMobile, context),
      backgroundColor: AppColors.background,
      body: NavBar(
        child:
            isMobile
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
                          margin: const EdgeInsets.only(left: 40),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  productName,
                                  rate,
                                  price,
                                  description,
                                ],
                              ),
                              action,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
