import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/card_product.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';
import 'package:market_partners/widgets/nav_bar.dart';

class SourceProduct extends StatefulWidget {
  final String sourcePrompt;
  const SourceProduct({super.key, required this.sourcePrompt});

  @override
  State<SourceProduct> createState() => _SourceProductState();
}

class _SourceProductState extends State<SourceProduct> {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  Map<String, Set<String>> allFilters = {};
  Map<String, String> filterLabels = {};
  Map<String, Set<String>> selectedFilters = {};
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

    final tmpAllFilters = <String, Set<String>>{};
    final tmpFilterLabels = <String, String>{};

    for (var p in data) {
      p.specifications.forEach((key, value) {
        final normalizedKey = key.trim().toLowerCase();
        final normalizedValue = value.trim();

        tmpAllFilters.putIfAbsent(normalizedKey, () => <String>{});
        tmpAllFilters[normalizedKey]!.add(normalizedValue);

        tmpFilterLabels.putIfAbsent(normalizedKey, () => key.trim());
      });
    }

    setState(() {
      products = data;
      filteredProducts = data;
      allFilters = tmpAllFilters;
      filterLabels = tmpFilterLabels;
      loading = false;
    });
  }

  void applyFilters() {
    setState(() {
      filteredProducts =
          products.where((product) {
            for (var entry in selectedFilters.entries) {
              final normalizedKey = entry.key;
              final selectedValues = entry.value;

              if (selectedValues.isNotEmpty) {
                final productValue =
                    product.specifications.entries
                        .firstWhere(
                          (e) => e.key.trim().toLowerCase() == normalizedKey,
                          orElse: () => const MapEntry("", ""),
                        )
                        .value
                        .trim();

                if (productValue.isEmpty ||
                    !selectedValues.contains(productValue)) {
                  return false;
                }
              }
            }
            return true;
          }).toList();
      filterMenu = false;
    });
  }

  void clearFilters() {
    setState(() {
      selectedFilters.clear();
      filteredProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidht = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    bool isMobile = IsMobile(context);

    List<CardProduct> productView =
        filteredProducts
            .map((product) => CardProduct(product: product))
            .toList();

    TextButton buttonFilter = TextButton(
      onPressed: () {
        setState(() {
          filterMenu = !filterMenu;
        });
      },
      child: Row(
        children: const [
          Icon(Icons.filter_alt_sharp, color: AppColors.blue),
          SizedBox(width: 4),
          Text("Filtrar", style: AppText.base),
        ],
      ),
    );

    Container widgetFilterMenu = Container(
      width: isMobile ? mediaQueryWidht : mediaQueryWidht * 0.4,
      height: isMobile ? mediaQueryHeight * 0.7 : mediaQueryHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: MyOutlinedButton(
                    onPressed: clearFilters,
                    child: const Text(
                      "Limpar Filtros",
                      style: TextStyle(color: AppColors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: MyFilledButton(
                    onPressed: applyFilters,
                    child: const Text(
                      "Aplicar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    allFilters.entries.map((entry) {
                      final normalizedKey = entry.key;
                      final values = entry.value;
                      final label =
                          filterLabels[normalizedKey] ?? normalizedKey;

                      return ExpansionTile(
                        title: Text(label, style: AppText.titleInfoTiny),
                        children:
                            values.map((value) {
                              final isSelected =
                                  selectedFilters[normalizedKey]?.contains(
                                    value,
                                  ) ??
                                  false;
                              return CheckboxListTile(
                                value: isSelected,
                                title: Text(value, style: AppText.base),
                                onChanged: (checked) {
                                  setState(() {
                                    selectedFilters.putIfAbsent(
                                      normalizedKey,
                                      () => <String>{},
                                    );
                                    if (checked == true) {
                                      selectedFilters[normalizedKey]!.add(
                                        value,
                                      );
                                    } else {
                                      selectedFilters[normalizedKey]!.remove(
                                        value,
                                      );
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      );
                    }).toList(),
              ),
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
        child: Container(color: Colors.black.withOpacity(0.3)),
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
                        : filteredProducts.isEmpty
                        ? const Center(
                          child: TranslatedText(
                            text: "Nenhum produto encontrado",
                          ),
                        )
                        : Wrap(children: productView),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset:
                  filterMenu
                      ? Offset.zero
                      : isMobile
                      ? const Offset(0, 1.0)
                      : const Offset(1.0, 0),
              child: Opacity(
                opacity: filterMenu ? 1.0 : 0.0,
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
