import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.memory(base64Decode(product.images[0]), width: 100),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(product.name),
                    Text("R\$ ${product.price}"),
                    Text(product.stock.toString()),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  color: AppColors.blue,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return popupDelete;
                      },
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
