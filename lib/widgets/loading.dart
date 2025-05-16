import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class widgetLoading extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final double height;
  final double width;

  const widgetLoading({
    super.key,
    this.verticalPadding = 170,
    this.height = 15,
    this.width = 170,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: LinearProgressIndicator(color: AppColors.blue),
        ),
      ),
    );
  }
}
