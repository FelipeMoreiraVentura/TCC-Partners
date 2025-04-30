import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class MyFilledButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double width;

  const MyFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
