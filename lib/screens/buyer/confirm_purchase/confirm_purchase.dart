import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/widget/address_config.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/widget/purchase_made.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/widget/total_price.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/widget/view_product.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_filled_button.dart';

class ConfirmPurchase extends StatefulWidget {
  final List<String> productId;
  const ConfirmPurchase({super.key, required this.productId});

  @override
  State<ConfirmPurchase> createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
  List<Map<String, dynamic>> products = [];
  bool isloding = true;

  @override
  void initState() {
    super.initState();
    getPurchaseProduct();
  }

  getPurchaseProduct() async {
    Map<String, List> data = await getProducts();
    final filtered =
        data["products"]!
            .where(
              (product) => widget.productId.contains(
                (product as Map<String, dynamic>)["id"],
              ),
            )
            .cast<Map<String, dynamic>>()
            .toList();

    setState(() {
      products = filtered;
      isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    AddressConfig addressConfig = AddressConfig();
    ViewProduct viewProduct = ViewProduct(products: products);

    String totalPrice = (products.fold(0.0, (sum, product) {
              return sum + (product["price"] as num).toDouble();
            }) +
            5)
        .toStringAsFixed(2);

    TotalPrice widgetTotalPrice = TotalPrice(
      products: products,
      totalPrice: totalPrice,
    );

    Container confirm = Container(
      margin: EdgeInsets.only(top: 10),
      child: MyFilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PurchaseMade()),
          );
        },
        child: Text("Comprar", style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: backAppbar("Confirmar compra"),
      backgroundColor: AppColors.background,
      body:
          isloding
              ? Center(child: widgetLoading())
              : Container(
                margin: EdgeInsets.all(10),
                child:
                    isMobile
                        ? SingleChildScrollView(
                          child: Column(
                            children: [
                              viewProduct,
                              widgetTotalPrice,
                              addressConfig,
                              confirm,
                            ],
                          ),
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            viewProduct,
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      addressConfig,
                                      SingleChildScrollView(
                                        child: widgetTotalPrice,
                                      ),
                                    ],
                                  ),
                                  confirm,
                                ],
                              ),
                            ),
                          ],
                        ),
              ),
    );
  }
}
