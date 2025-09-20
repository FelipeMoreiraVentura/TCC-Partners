import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Páginas
import 'package:market_partners/screens/buyer_seller/login/login.dart';
import 'package:market_partners/screens/buyer/home/home.dart';
import 'package:market_partners/screens/buyer/configurations/config.dart';
import 'package:market_partners/screens/buyer/partnersBot/partners_bot.dart';
import 'package:market_partners/screens/buyer_seller/history/history.dart';
import 'package:market_partners/screens/buyer/cart/cart.dart';
import 'package:market_partners/screens/buyer/source_product/source_product.dart';
import 'package:market_partners/screens/buyer/product/product.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/confirm_purchase.dart';
import 'package:market_partners/screens/buyer_seller/purchase/purchase.dart';

import 'package:market_partners/screens/seller/home/home.dart';
import 'package:market_partners/screens/seller/new_or_edit_product/new_or_edit_product.dart';
import 'package:market_partners/screens/seller/products/products.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

abstract class AppRoute {
  static const login = 'login';

  // Buyer
  static const homeBuyer = 'homeBuyer';
  static const configuration = 'configuration';
  static const partnersBot = 'partnersBot';
  static const history = 'history';
  static const cart = 'cart';
  static const sourceProduct = 'sourceProduct';
  static const product = 'product';
  static const confirmPurchase = 'confirmPurchase';
  static const purchase = 'purchase';

  // Seller
  static const homeSeller = 'homeSeller';
  static const newProduct = 'newProduct';
  static const products = 'products';
  static const sales = 'sales';
  static const sale = 'sale';
  static const editProduct = 'editProduct';
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/HomeBuyer',
  routes: [
    // --- Login ---
    GoRoute(
      path: '/login',
      name: AppRoute.login,
      builder: (context, state) => const Login(),
    ),

    // --- Buyer ---
    GoRoute(
      path: '/HomeBuyer',
      name: AppRoute.homeBuyer,
      builder: (context, state) => const HomeBuyer(),
    ),
    GoRoute(
      path: '/configuration',
      name: AppRoute.configuration,
      builder: (context, state) => const Config(),
      routes: [
        GoRoute(
          path: 'PartnersBot',
          name: AppRoute.partnersBot,
          builder: (context, state) => const PartnersBot(),
        ),
      ],
    ),
    GoRoute(
      path: '/history',
      name: AppRoute.history,
      builder: (context, state) => const History(),
    ),
    GoRoute(
      path: '/cart',
      name: AppRoute.cart,
      builder: (context, state) => const Cart(),
    ),
    GoRoute(
      path: '/source_product/:prompt',
      name: AppRoute.sourceProduct,
      builder: (context, state) {
        final prompt = state.pathParameters['prompt'] ?? '';
        return SourceProduct(
          key: ValueKey('source-$prompt'),
          sourcePrompt: prompt,
        );
      },
    ),
    GoRoute(
      path: '/product/:id',
      name: AppRoute.product,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return Product(key: ValueKey('product-$id'), id: id);
      },
    ),
    GoRoute(
      path: '/confirm_purchase/:ids',
      name: AppRoute.confirmPurchase,
      builder: (context, state) {
        final idsParam = state.pathParameters['ids'] ?? '';
        final productIds = idsParam.isEmpty ? <String>[] : idsParam.split(',');
        return ConfirmPurchase(productId: productIds);
      },
    ),
    GoRoute(
      path: '/purchase/:purchaseId',
      name: AppRoute.purchase,
      builder: (context, state) {
        final purchaseId = state.pathParameters['purchaseId'] ?? '';
        return Purchase(purchaseId: purchaseId);
      },
    ),

    // --- Seller ---
    GoRoute(
      path: '/HomeSeller',
      name: AppRoute.homeSeller,
      builder: (context, state) => const HomeSeller(),
    ),
    GoRoute(
      path: '/newProduct',
      name: AppRoute.newProduct,
      builder: (context, state) => const NewOrEditProduct(),
    ),
    GoRoute(
      path: '/editProduct/:id',
      name: AppRoute.editProduct,
      builder: (context, state) {
        final productId = state.pathParameters["id"] ?? "";
        return NewOrEditProduct(productId: productId);
      },
    ),
    GoRoute(
      path: '/products',
      name: AppRoute.products,
      builder: (context, state) => const Products(),
    ),
    GoRoute(
      path: '/sales',
      name: AppRoute.sales,
      builder: (context, state) => const History(isSeller: true),
    ),
    GoRoute(
      path: '/sale/:purchaseId',
      name: AppRoute.sale,
      builder: (context, state) {
        final purchaseId = state.pathParameters['purchaseId'] ?? '';
        return Purchase(purchaseId: purchaseId, isSeller: true);
      },
    ),
  ],

  errorBuilder: (context, state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(AppRoute.homeBuyer);
    });
    return const SizedBox.shrink();
  },
);

class Routes {
  static String sourceProduct(String prompt) =>
      '/source_product/${Uri.encodeComponent(prompt)}';

  static String product(String id) => '/product/${Uri.encodeComponent(id)}';

  static String confirmPurchase(List<String> ids) =>
      '/confirm_purchase/${ids.map(Uri.encodeComponent).join(",")}';

  static String purchase(String purchaseId) =>
      '/purchase/${Uri.encodeComponent(purchaseId)}';
}
