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

  const HistoryCard({super.key, required this.purchase, required this.isBuyer});

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

    Column historyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${date?.day.toString().padLeft(2, '0')}/"
          "${date?.month.toString().padLeft(2, '0')}/"
          "${date?.year} - "
          "${date?.hour.toString().padLeft(2, '0')}:"
          "${date?.minute.toString().padLeft(2, '0')}",
          style: AppText.titleInfoTiny,
        ),
        SizedBox(height: 4),
        TranslatedText(text: "Id da Compra: ${widget.purchase.id}"),
        SizedBox(height: 8),
        Text("Valor Total: R\$ ${widget.purchase.price.toStringAsFixed(2)}"),
      ],
    );
    return InkWell(
      onTap: () {
        if (widget.isBuyer) {
          navNamed(
            context,
            AppRoute.purchase,
            path: {'purchaseId': widget.purchase.id ?? ''},
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.menu,
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            historyInfo,
            SizedBox(height: 8),
            if (product != null) ...[
              Image.memory(
                base64Decode(product!.images[0]),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(product!.name, style: AppText.titleInfoTiny),
            ],
          ],
        ),
      ),
    );
  }
}
