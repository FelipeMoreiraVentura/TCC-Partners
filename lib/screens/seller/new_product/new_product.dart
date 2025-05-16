import 'package:flutter/material.dart';
import 'package:market_partners/screens/seller/new_product/widget/product_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: backAppbar("Novo Produto"),
      body: ProductImage(name: name, description: description),
      // body: ,
    );
  }
}
