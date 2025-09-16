import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/models/product.dart';
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
  List<ProductModel> products = [];
  List<Map<String, String>> filters = [];
  bool loading = true;

  bool filterMenu = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await ProductService().searchProductsByName(
      widget.sourcePrompt,
    );
    setState(() {
      products = data;
      loading = false;
      filters =
          data
              .expand(
                (d) => d.specifications.entries.map((e) => {e.key: e.value}),
              )
              .toSet()
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidht = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

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

    Container widgetFilterMenu = Container(
      width: isMobile ? mediaQueryWidht : mediaQueryWidht * 0.4,
      height: isMobile ? mediaQueryHeight * 0.6 : mediaQueryHeight,
      color: AppColors.menuBackground,
      child: Column(
        children: [
          buttonFilter,
          SingleChildScrollView(
            child: Column(
              children:
                  filters.map((f) {
                    return Row(
                      children:
                          f.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("${entry.key}: ${entry.value}"),
                            );
                          }).toList(),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );

    Expanded closeFilterMenu = Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filterMenu = false;
          });
        },
        child: Container(color: Colors.transparent),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: infoAppbar(isMobile, context),
      body: Stack(
        children: [
          NavBar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    loading
                        ? widgetLoading()
                        : products.isEmpty
                        ? Center(child: Text("Nenhum produto encontrado"))
                        : Wrap(children: productView),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Opacity(
              opacity: filterMenu ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset:
                    filterMenu
                        ? Offset.zero
                        : isMobile
                        ? Offset(0, 1.0)
                        : Offset(1.0, 0),
                child:
                    isMobile
                        ? Column(children: [closeFilterMenu, widgetFilterMenu])
                        : Row(children: [closeFilterMenu, widgetFilterMenu]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
