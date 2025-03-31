import 'package:flutter/material.dart';
import 'package:market_partners/screens/home/widgets/Carousel.dart';
import 'package:market_partners/screens/home/widgets/products.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/utils/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isMobile)
              Image.asset(
                "assets/images/logoStringWhite.png",
                height: 43,
                width: 200,
              ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 40,
                  child: TextField(
                    obscureText: false,
                    style: AppText.md.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      hintText: "Pesquisar",
                      hintStyle: AppText.md.copyWith(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_rounded, color: Colors.white),
            ),
            PopupMenuButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: "/configuration",
                      child: Text("Configurações"),
                    ),
                    PopupMenuItem(value: "/login", child: Text("Logout")),
                  ],
              onSelected: (value) {
                Navigator.pushNamed(context, value);
              },
            ),
          ],
        ),
      ),
      body: NavBar(
        child: Container(
          decoration: BoxDecoration(color: AppColors.background),
          child: Column(
            children: [
              Center(child: carousel(isMobile, sizeScreen)),
              Products(isMobile: isMobile, sizeScreen: sizeScreen),
            ],
          ),
        ),
      ),
    );
  }
}
