import 'package:flutter/material.dart';
import 'package:market_partners/mock/product_comment_mock.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/screens/buyer/product/widgets/comments.dart';
import 'package:market_partners/screens/buyer/product/widgets/product_info.dart';
import 'package:market_partners/screens/buyer/product/widgets/product_specifications.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/widgets/wrap_product.dart';

class Product extends StatefulWidget {
  final String id;
  const Product({super.key, required this.id});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool loading = true;
  Map<String, dynamic> product = {};
  List<Map<String, Object>> productComments = [];
  List products = [];

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  void loadProduct() async {
    final dataProduct = await getProducts();
    final dataComment = await getProductsComments();
    setState(() {
      product = (dataProduct["products"] as List).firstWhere(
        (p) => p["id"] == widget.id,
        orElse: () => {},
      );
      products = dataProduct["products"]!;
      productComments = dataComment;
      if (product.isNotEmpty && productComments.isNotEmpty) loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    return Scaffold(
      appBar: infoAppbar(isMobile, context),
      backgroundColor: AppColors.background,
      body: NavBar(
        child: SingleChildScrollView(
          child:
              loading
                  ? Center(child: widgetLoading())
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductInfo(product: product),

                        SizedBox(height: 10),
                        ProductSpecifications(
                          specifications: product["specifications"],
                        ),

                        SizedBox(height: 10),
                        Text("Recomendados", style: AppText.titleInfoMedium),
                        Center(
                          child: WrapProduct(
                            products: products.cast<Map<String, Object>>(),
                          ),
                        ),

                        SizedBox(height: 10),
                        Comments(
                          comments: productComments,
                          rating: product["rating"],
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
