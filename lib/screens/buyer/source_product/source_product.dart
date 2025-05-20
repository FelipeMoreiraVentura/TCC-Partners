import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/card_product.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';

class SourceProduct extends StatefulWidget {
  final String sourcePrompt;
  const SourceProduct({super.key, required this.sourcePrompt});

  @override
  State<SourceProduct> createState() => _SourceProductState();
}

class _SourceProductState extends State<SourceProduct> {
  List products = [];
  bool loading = true;

  bool filterMenu = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await getProducts();
    setState(() {
      products = data["products"]!;
      if (products.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    List<CardProduct> productView =
        products.map((product) {
          return CardProduct(product: product);
        }).toList();

    TextButton buttonFilter = TextButton(
      onPressed: () {
        setState(() {
          filterMenu = !filterMenu;
        });
      },
      child: Row(
        children: [
          Icon(Icons.filter_alt_sharp, color: AppColors.blue),
          Text("Filtrar"),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: infoAppbar(isMobile, context),
      body: Stack(
        children: [
          NavBar(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Resultados da pesquisa:",
                      style:
                          isMobile
                              ? AppText.titleInfoTiny
                              : AppText.titleInfoMedium,
                    ),
                    buttonFilter,
                  ],
                ),
                loading ? widgetLoading() : Wrap(children: productView),
              ],
            ),
          ),
          if (filterMenu)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                color: AppColors.menuBackground,
                height: double.infinity,
                width: 600,
                child: Column(children: [buttonFilter]),
              ),
            ),
        ],
      ),
    );
  }
}
