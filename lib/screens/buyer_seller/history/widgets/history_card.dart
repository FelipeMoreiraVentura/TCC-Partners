import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/go_or_push_named.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';

class HistoryCard extends StatefulWidget {
  final PurchaseModel purchase;
  final bool isBuyer;

  const HistoryCard({
    super.key,
    required this.purchase,
    required this.isBuyer,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  ProductModel? product;

  @override
  void initState() {
    super.initState();
    getProductDetails();
  }

  getProductDetails() async {
    final data = await ProductService().getProduct(widget.purchase.productId);
    setState(() {
      product = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.purchase.createdAt;

    final String formattedDate =
        "${date?.day.toString().padLeft(2, '0')}/"
        "${date?.month.toString().padLeft(2, '0')}/"
        "${date?.year} - "
        "${date?.hour.toString().padLeft(2, '0')}:"
        "${date?.minute.toString().padLeft(2, '0')}";

    return InkWell(
      onTap: () {
        if (widget.isBuyer) {
          navNamed(
            context,
            AppRoute.purchase,
            path: {'purchaseId': widget.purchase.id ?? ''},
          );
        } else {
          navNamed(
            context,
            AppRoute.sale,
            path: {'purchaseId': widget.purchase.id ?? ''},
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product != null)
                Image.memory(
                  base64Decode(product!.images[0]),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              if (product != null) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formattedDate, style: AppText.titleInfoTiny),
                    if (product != null) ...[
                      Text(
                        product!.name,
                        style: AppText.titleInfoTiny,
                      ),
                    ],
                    const SizedBox(height: 4),
                    TranslatedText(
                        text: "Id da Compra: ${widget.purchase.id}"),
                    const SizedBox(height: 8),
                    Text(
                      "Valor Total: R\$ ${widget.purchase.price.toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
