import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class MyOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double width;

  const MyOutlinedButton({
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
          backgroundColor: const Color.fromARGB(255, 219, 219, 219),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.blue, width: 1),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
