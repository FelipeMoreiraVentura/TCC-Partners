import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/purchase.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
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
  List<ProductModel> products = [];
  bool isloding = true;

  @override
  void initState() {
    super.initState();
    getPurchaseProduct();
  }

  getPurchaseProduct() async {
    List<ProductModel> productsData = await ProductService().getProducts(
      widget.productId,
    );

    setState(() {
      products = productsData;
      isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    confirmPurchase() async {
      if (products.isEmpty) return;

      for (var product in products) {
        PurchaseModel purchase = PurchaseModel(
          buyerId: UserService().getUid() ?? '',
          productId: product.id ?? '',
          price: product.price,
          createdAt: DateTime.now(),
          sellerId: product.sellerUid,
        );
        await PurchaseService().createPurchase(purchase: purchase);
      }
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => PurchaseMade()),
      );
    }

    bool isMobile = IsMobile(context);

    AddressConfig addressConfig = AddressConfig();
    ViewProduct viewProduct = ViewProduct(products: products);

    String totalPrice = (products.fold(0.0, (sum, product) {
              return sum + (product.price as num).toDouble();
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
          confirmPurchase();
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
