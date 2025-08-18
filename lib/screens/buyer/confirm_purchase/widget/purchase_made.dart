import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/my_filled_button.dart';

class PurchaseMade extends StatelessWidget {
  const PurchaseMade({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = IsMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: isMobile ? 80 : 120,
                ),
                const SizedBox(height: 24),
                Text(
                  "Compra Realizada com Sucesso!",
                  textAlign: TextAlign.center,
                  style: isMobile ? AppText.titleMedium : AppText.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Verifique na aba de produtos para acompanhar o status da entrega.",
                  textAlign: TextAlign.center,
                  style: AppText.description.copyWith(
                    fontSize: isMobile ? 14 : 18,
                  ),
                ),
                const SizedBox(height: 32),
                MyFilledButton(
                  child: Text("Voltar", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    context.pushNamed(AppRoute.homeBuyer);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
