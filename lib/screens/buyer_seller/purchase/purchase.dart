import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/reviews.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/screens/buyer_seller/purchase/widgets/add_review.dart';
import 'package:market_partners/screens/buyer_seller/purchase/widgets/view_review.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/widgets/photos_desktop.dart';
import 'package:market_partners/widgets/photos_mobile.dart';

class Purchase extends StatefulWidget {
  final String purchaseId;
  final bool isSeller;

  const Purchase({super.key, required this.purchaseId, this.isSeller = false});

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

  void respondToReview(String sellerComment) async {
    if (review == null) return;
    final updatedReview = ReviewsModels(
      buyerId: review!.buyerId,
      sellerId: review!.sellerId,
      buyerComment: review!.buyerComment,
      purchaseId: review!.purchaseId,
      sellerComment: sellerComment,
      rating: review!.rating,
      productId: review!.productId,
    );
    await ReviewsService().updateReview(updatedReview);
    setState(() {
      review = updatedReview;
    });
  }

  Widget buildReviewSection() {
    if (widget.isSeller) {
      // Modo vendedor
      if (review != null && review!.buyerComment.isNotEmpty) {
        return ViewReview(
          isSeller: widget.isSeller,
          review: review!,
          showSellerResponseField: true,
          onRespond: respondToReview,
        );
      } else {
        return const Text("Sem resposta do comprador.");
      }
    } else {
      return review != null
          ? ViewReview(review: review!, isSeller: widget.isSeller)
          : Review(review: review, addReview: addReview);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    Text widgetProductName = Text(
      product?.name ?? "",
      style: AppText.titleInfoMedium,
    );

    Widget content =
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
                            buildReviewSection(),
                          ],
                        )
                        : Row(
                          children: [
                            Photosdesktop(images: product!.images),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widgetProductName,
                                  const SizedBox(height: 10),
                                  buildReviewSection(),
                                ],
                              ),
                            ),
                          ],
                        ),
              ),
            );

    return Scaffold(
      appBar: backAppbar("Detalhes da Compra"),
      backgroundColor: AppColors.background,
      body: widget.isSeller ? content : NavBar(child: content),
    );
  }
}
