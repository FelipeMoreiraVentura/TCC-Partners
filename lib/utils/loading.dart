import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

Widget widgetLoading() {
  return SizedBox(
    height: 200,
    width: double.infinity,
    child: Center(
      child: SizedBox(
        height: 15,
        width: 170,
        child: LinearProgressIndicator(color: AppColors.blue),
      ),
    ),
  );
}
