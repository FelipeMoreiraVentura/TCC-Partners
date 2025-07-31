import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Image.memory(base64Decode(product.images[0]), width: 100),
          Column(children: [Text(product.name), Text("R\$ ${product.price}")]),
        ],
      ),
    );
  }
}
