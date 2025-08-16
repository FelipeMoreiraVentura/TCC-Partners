import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/reviews.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/screens/buyer/purchase/widgets/add_review.dart';
import 'package:market_partners/screens/buyer/purchase/widgets/view_review.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/widgets/photos_desktop.dart';
import 'package:market_partners/widgets/photos_mobile.dart';

class Purchase extends StatefulWidget {
  final String purchaseId;
  const Purchase({super.key, required this.purchaseId});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  PurchaseModel? purchase;
  ProductModel? product;
  ReviewsModels? review;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final purchaseData = await PurchaseService().getPurchase(widget.purchaseId);
    final productData = await ProductService().getProduct(
      purchaseData!.productId,
    );
    final reviewData = await ReviewsService().getReviewByPurchaseId(
      purchaseData.id ?? '',
    );

    setState(() {
      purchase = purchaseData;
      product = productData;
      review = reviewData;
      loading = false;
    });
  }

  void addReview(String avality, int rating) async {
    ReviewsModels reviewData = ReviewsModels(
      buyerId: purchase!.buyerId,
      sellerId: purchase!.sellerId,
      buyerComment: avality,
      purchaseId: purchase!.id,
      sellerComment: "",
      rating: rating,
      productId: purchase!.productId,
    );
    await ReviewsService().addReview(reviewData);
    setState(() {
      review = reviewData;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    Text widgetProductName = Text(
      product!.name,
      style: AppText.titleInfoMedium,
    );

    return Scaffold(
      appBar: backAppbar("Detalhes da Compra"),
      backgroundColor: AppColors.background,
      body: NavBar(
        child:
            loading
                ? widgetLoading()
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        isMobile
                            ? Column(
                              children: [
                                widgetProductName,
                                PhotosMobile(images: product!.images),
                                Review(review: review, addReview: addReview),
                              ],
                            )
                            : Row(
                              children: [
                                Photosdesktop(images: product!.images),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widgetProductName,
                                      review != null
                                          ? ViewReview(review: review)
                                          : Review(
                                            review: review,
                                            addReview: addReview,
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
      ),
    );
  }
}
