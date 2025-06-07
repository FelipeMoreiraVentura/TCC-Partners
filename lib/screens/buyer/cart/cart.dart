import 'package:flutter/material.dart';
import 'package:market_partners/mock/products_mock.dart';
import 'package:market_partners/screens/buyer/cart/widget/card_product.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/nav_bar.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoding = true;

  @override
  void initState() {
    super.initState();
    getProductsCart();
  }

  List<Map<String, dynamic>> products = [];

  getProductsCart() async {
    Map<String, List> data = await getProducts();

    setState(() {
      products = (data["products"] ?? []).cast<Map<String, dynamic>>();
      isLoding = false;
    });
  }

  List<String> productsChecked = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> podructsFilter =
        products.where((p) => productsChecked.contains(p["id"])).toList();
    double totalPrice = podructsFilter.fold(
      0.0,
      (sum, p) => sum + ((p["price"] ?? 0) as num).toDouble(),
    );

    void chekedControll({required bool value, required String id}) {
      setState(() {
        if (value) {
          productsChecked.add(id);
        } else {
          productsChecked.remove(id);
        }
      });
    }

    List<CardProduct> cardProducts =
        products.map((product) {
          return CardProduct(
            product: product,
            productsChecked: productsChecked,
            chekedControll: chekedControll,
          );
        }).toList();

    Container purchaseBar = Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.menu,
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Total: R\$ ${totalPrice.toStringAsFixed(2)}",
            style: AppText.titleInfoTiny,
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: MyFilledButton(
              onPressed:
                  productsChecked.isEmpty
                      ? null
                      : () {
                        Navigator.pushNamed(
                          context,
                          "/confirm_purchase/${productsChecked.join(",")}",
                        );
                      },
              child: const Text(
                "Comprar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: backAppbar("Carrinho"),
      backgroundColor: AppColors.background,
      body: NavBar(
        child:
            isLoding
                ? Center(child: widgetLoading())
                : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        top: 70,
                        left: 8,
                        right: 8,
                      ),
                      children: cardProducts,
                    ),
                    purchaseBar,
                  ],
                ),
      ),
    );
  }
}
