import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/global.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/popup_create_account.dart';

AppBar infoAppbar(bool isMobile, context) {
  User? user = FirebaseAuth.instance.currentUser;

  return AppBar(
    backgroundColor: AppColors.blue,
    surfaceTintColor: Colors.transparent,
    automaticallyImplyLeading: isMobile,
    iconTheme: IconThemeData(color: Colors.white),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isMobile)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/HomeBuyer");
            },
            icon: Image.asset(
              "assets/images/logoStringWhite.png",
              height: 43,
              width: 200,
            ),
          ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 40,
              child: TextField(
                onSubmitted: (value) {
                  Navigator.pushNamed(
                    context,
                    "source_product/${sourcePrompt.text}",
                  );
                },
                controller: sourcePrompt,
                obscureText: false,
                style: AppText.md.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  hintText: "Pesquisar",
                  hintStyle: AppText.md.copyWith(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (sourcePrompt.text.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    "source_product/${sourcePrompt.text}",
                  );
                }
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            if (user != null) {
              Navigator.pushNamed(context, "/cart");
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return PopupCreateAccount();
                },
              );
            }
          },
          icon: Icon(Icons.shopping_cart_rounded, color: Colors.white),
        ),
      ],
    ),
  );
}
