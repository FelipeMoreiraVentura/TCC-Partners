import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/reviews.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/screens/buyer/product/widgets/comments.dart';
import 'package:market_partners/screens/buyer/product/widgets/product_info.dart';
import 'package:market_partners/screens/buyer/product/widgets/product_specifications.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
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
  ProductModel? product;
  List<ProductModel> products = [];
  List<ReviewsModels>? review;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  void loadProduct() async {
    ProductModel productData = await ProductService().getProduct(widget.id);
    List<ProductModel> productsData = await ProductService().getRandomProducts(
      16,
    );
    List<ReviewsModels> reviewData = await ReviewsService().getReviews(
      widget.id,
      "productId",
    );
    setState(() {
      product = productData;
      products = productsData;
      review = reviewData;
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
              product == null
                  ? Center(child: widgetLoading())
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductInfo(product: product!, reviews: review),

                        SizedBox(height: 10),
                        if(product!.specifications.isNotEmpty)
                          ProductSpecifications(
                            specifications: product!.specifications,
                          ),

                        SizedBox(height: 10),
                        TranslatedText(
                          text: "Recomendados",
                          style: AppText.titleInfoMedium,
                        ),
                        Center(child: WrapProduct(products: products)),

                        SizedBox(height: 10),
                        Comments(reviews: review),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
