import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class CardSeller extends StatelessWidget {
  final String label;
  final Icon icon;
  final String routeName;
  const CardSeller({
    super.key,
    required this.label,
    required this.icon,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 300,
        height: 300,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(colorSpace: ColorSpace.sRGB),
              spreadRadius: 0.2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(children: [icon, Text(label, style: AppText.titleLarge)]),
      ),
    );
  }
}
