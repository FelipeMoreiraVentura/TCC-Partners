import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/cart.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/widgets/photos_desktop.dart';
import 'package:market_partners/widgets/photos_mobile.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';
import 'package:market_partners/widgets/popup_create_account.dart';
import 'package:market_partners/widgets/stars_rating.dart';

class ProductInfo extends StatefulWidget {
  final ProductModel product;
  final List<ReviewsModels>? reviews;
  const ProductInfo({super.key, required this.product, required this.reviews});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    ProductModel product = widget.product;

    Text productName = Text(
      product.name,
      style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
    );

    Text price = Text(
      "R\$ ${product.price.toString()}",
      style: isMobile ? AppText.lg : AppText.xl,
      softWrap: true,
    );

    final double avg =
        widget.reviews!.isEmpty
            ? 0.0
            : widget.reviews!.fold<int>(0, (acc, r) => acc + r.rating) /
                widget.reviews!.length;

    final rate = StarRating(rating: avg);

    Text description = Text(
      product.description,
      style: AppText.sm.merge(AppText.description),
      softWrap: true,
    );

    Column action = Column(
      children: [
        MyOutlinedButton(
          onPressed: () {
            if (user != null) {
              CartService().addItemToCart(
                userId: user!.uid,
                productId: product.id ?? '',
              );
              Navigator.pushNamed(context, "/cart");
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return PopupCreateAccount();
                },
              );
            }
          },
          child: Text(
            "Adicionar ao Carrinho",
            style: TextStyle(color: AppColors.blue),
          ),
        ),
        SizedBox(height: 10),
        MyFilledButton(
          onPressed: () {
            if (user != null) {
              Navigator.pushNamed(context, "confirm_purchase/${product.id}");
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return PopupCreateAccount();
                },
              );
            }
          },
          child: Text("Comprar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );

    return isMobile
        ? Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productName,
              PhotosMobile(images: product.images),
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
              Photosdesktop(images: product.images),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productName,
                          rate,
                          price,
                          SizedBox(
                            height: 300,
                            child: SingleChildScrollView(child: description),
                          ),
                        ],
                      ),
                      action,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
