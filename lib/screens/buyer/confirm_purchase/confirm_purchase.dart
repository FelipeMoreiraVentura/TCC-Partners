import 'package:flutter/material.dart';
import 'package:market_partners/screens/buyer/confirm_purchase/widget/address_config.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';

class ConfirmPurchase extends StatefulWidget {
  final List<String> productId;
  const ConfirmPurchase({super.key, required this.productId});

  @override
  State<ConfirmPurchase> createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
  String selectesAddress = "124";

  late AddressConfig addressConfig;

  @override
  void initState() {
    super.initState();
    addressConfig = AddressConfig(selectesAddress: selectesAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppbar("Confirmar compra"),
      backgroundColor: AppColors.background,
      body: addressConfig,
    );
  }
}
