import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

AppBar backAppbar(String label) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    title: Text(label, style: AppText.lg.copyWith(color: Colors.white)),
    backgroundColor: AppColors.blue,
  );
}
