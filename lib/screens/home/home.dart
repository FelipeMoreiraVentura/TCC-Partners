import 'package:flutter/material.dart';
import 'package:market_partners/screens/home/widgets/Carousel.dart';
import 'package:market_partners/utils/isMobile.dart';
import 'package:market_partners/widgets/navBar.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!isMobile)
                Image.asset("images/logoString.png", height: 43, width: 200),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(
                          20,
                          15,
                          20,
                          15,
                        ),
                        hintText: "Pesquisar",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart_rounded),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                icon: Icon(Icons.account_circle),
              ),
            ],
          ),
        ),
      ),
      body: NavBar(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: isMobile ? Radius.circular(10) : Radius.zero,
            ),
          ),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: sizeScreen.width * 0.9,
                  height: sizeScreen.height * 0.6,
                  child: carousel(isMobile, sizeScreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
