import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/style.dart';

class CardProduct extends StatelessWidget {
  final ProductModel product;
  final List<String> productsChecked;
  final Function({required bool value, required String id}) chekedControll;

  const CardProduct({
    super.key,
    required this.product,
    required this.productsChecked,
    required this.chekedControll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.menu,
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/product/${product.id}");
                },
                child: Image.memory(
                  base64Decode(product.images[0]),
                  width: 80,
                  height: 80,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(product.name), Text(product.price.toString())],
              ),
            ],
          ),
          Checkbox(
            activeColor:
                productsChecked.contains(product.id) ? AppColors.blue : null,
            value: productsChecked.contains(product.id),
            onChanged: (bool? value) {
              chekedControll(value: value ?? false, id: product.id ?? '');
            },
          ),
        ],
      ),
    );
  }
}
