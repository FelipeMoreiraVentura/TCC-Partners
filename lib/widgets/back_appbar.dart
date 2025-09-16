import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';

AppBar backAppbar(String label) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    title: TranslatedText(
      text: label,
      style: AppText.lg.copyWith(color: Colors.white),
    ),
    backgroundColor: AppColors.blue,
  );
}
