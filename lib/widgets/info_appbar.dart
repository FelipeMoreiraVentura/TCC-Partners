import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/global.dart';
import 'package:market_partners/utils/go_or_push_named.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/popup_create_account.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
              navNamed(context, AppRoute.homeBuyer);
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
              child: TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: sourcePrompt,
                  style: AppText.md.copyWith(color: Colors.white),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      navNamed(
                        context,
                        AppRoute.sourceProduct,
                        path: {'prompt': value.trim()},
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: AppText.md.copyWith(color: Colors.white70),
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                suggestionsCallback: (pattern) async {
                  if (pattern.trim().isEmpty) return [];
                  return await ProductService().getProductNameSuggestions(
                    pattern,
                  );
                },

                itemBuilder: (context, String suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSuggestionSelected: (String suggestion) {
                  sourcePrompt.text = suggestion;
                  navNamed(
                    context,
                    AppRoute.sourceProduct,
                    path: {'prompt': suggestion},
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                if (sourcePrompt.text.isNotEmpty) {
                  navNamed(
                    context,
                    AppRoute.sourceProduct,
                    path: {'prompt': sourcePrompt.text},
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
              navNamed(context, AppRoute.cart);
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
