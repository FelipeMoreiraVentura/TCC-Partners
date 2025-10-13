import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/go_or_push_named.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/popup.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final void Function(String) handleDeleteProduct;
  const ProductCard({
    super.key,
    required this.product,
    required this.handleDeleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    Popup popupDelete = Popup(
      title: "Deletar Produto",
      actionButtons: true,
      confirmAction: () {
        handleDeleteProduct(product.id ?? '');
        Navigator.of(context).pop();
      },
      child: TranslatedText(
        text: "Tem certeza que deseja deletar este produto?",
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              base64Decode(product.images[0]),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("R\$ ${product.price}"),
                  Text(product.stock.toString()),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    navNamed(
                      context,
                      AppRoute.editProduct,
                      path: {'id': product.id!},
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: AppColors.blue,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => popupDelete,
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
