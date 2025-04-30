import 'package:flutter/material.dart';
import 'package:market_partners/screens/buyer/home/widgets/carousel.dart';
import 'package:market_partners/screens/buyer/home/widgets/products.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/widgets/info_appbar.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/utils/style.dart';

class HomeBuyer extends StatefulWidget {
  const HomeBuyer({super.key});

  @override
  State<HomeBuyer> createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: infoAppbar(isMobile, context),
      body: NavBar(
        child: Container(
          decoration: BoxDecoration(color: AppColors.background),
          child: Column(
            children: [
              Center(child: Carousel()),
              Products(isMobile: isMobile, sizeScreen: sizeScreen),
            ],
          ),
        ),
      ),
    );
  }
}
