import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/reviews.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    Text productName = Text(
      product!.name,
      style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
    );

    List<Widget> purchaseDetails = [
      Column(
        children: [
          Text("Data da Compra:", style: AppText.titleInfoTiny),
          Text("${purchase!.createdAt}", style: AppText.description),
        ],
      ),
      Column(
        children: [
          Text("ID da Compra:", style: AppText.titleInfoTiny),
          Text("${purchase!.id}", style: AppText.description),
        ],
      ),
      Column(
        children: [
          Text("ID do Produto:", style: AppText.titleInfoTiny),
          Text(purchase!.productId, style: AppText.description),
        ],
      ),
      Column(
        children: [
          Text("Valor Total:", style: AppText.titleInfoTiny),
          Text(
            "R\$ ${purchase!.price.toStringAsFixed(2)}",
            style: AppText.description,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: backAppbar("Detalhes da Compra"),
      backgroundColor: AppColors.background,
      body: NavBar(
        child:
            loading
                ? widgetLoading()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isMobile
                            ? Column(
                              children: [
                                productName,
                                Image.memory(base64Decode(product!.images[0])),
                                SizedBox(height: 8),
                                ...purchaseDetails,
                              ],
                            )
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.memory(
                                  base64Decode(product!.images[0]),
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [productName, ...purchaseDetails],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
        // ...existing code...
      ),
    );
  }
}
