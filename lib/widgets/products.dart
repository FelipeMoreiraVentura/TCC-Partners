// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/utils/style.dart';

class Products extends StatefulWidget {
  final bool isMobile;
  final sizeScreen;

  const Products({super.key, required this.isMobile, required this.sizeScreen});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool loading = true;
  List products = [];

  final CarouselSliderController controller = CarouselSliderController();

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
    List<Widget> widgetsProductsMostPurchased =
        products.map((product) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/product");
            },
            child: Container(
              padding: EdgeInsets.all(widget.isMobile ? 5 : 10),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.menu,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.2,
                    blurRadius: 8,
                  ),
                ],
              ),
              height: widget.isMobile ? 150 : 200,
              width: widget.isMobile ? 150 : 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    product["images"][0],
                    height: widget.isMobile ? 60 : 90,
                    width: widget.isMobile ? 60 : 90,
                  ),
                  Text(
                    product["name"],
                    style: widget.isMobile ? AppText.xs : AppText.sm,
                  ),
                  Text(product["price"].toString(), style: AppText.md),
                ],
              ),
            ),
          );
        }).toList();

    List<Widget> widgetsRecommendedProducts =
        products.take(16).map((product) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/product");
            },
            child: Container(
              padding: EdgeInsets.all(widget.isMobile ? 5 : 10),
              height: widget.isMobile ? 180 : 210,
              width: widget.isMobile ? 180 : 210,
              color: AppColors.menu,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    product["images"][0],
                    height: widget.isMobile ? 70 : 100,
                    width: widget.isMobile ? 70 : 100,
                  ),
                  Text(
                    product["name"],
                    style: widget.isMobile ? AppText.xs : AppText.base,
                  ),
                  Text(product["price"].toString(), style: AppText.md),
                ],
              ),
            ),
          );
        }).toList();

    return Column(
      children: [
        loading
            ? widgetLoading()
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!widget.isMobile)
                  IconButton(
                    onPressed: () => controller.previousPage(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                Expanded(
                  child: CarouselSlider(
                    items: widgetsProductsMostPurchased,
                    carouselController: controller,
                    options: CarouselOptions(
                      height: widget.isMobile ? 150 : 200,
                      enableInfiniteScroll: false,
                      viewportFraction:
                          widget.isMobile
                              ? 180 / widget.sizeScreen.width
                              : 300 / widget.sizeScreen.width,
                      padEnds: false,
                    ),
                  ),
                ),
                if (!widget.isMobile)
                  IconButton(
                    onPressed: () => controller.nextPage(),
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
              ],
            ),
        SizedBox(height: 20),

        loading
            ? widgetLoading()
            : Container(
              margin:
                  widget.isMobile ? null : EdgeInsets.only(left: 5, right: 5),
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: widgetsRecommendedProducts,
              ),
            ),
      ],
    );
  }
}
