import 'package:flutter/material.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/go_or_push_named.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupCreateAccount extends StatelessWidget {
  const PopupCreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Popup(
      title: "Criar Conta",
      actionButtons: true,
      confirmAction: () {
        navNamed(context, AppRoute.login);
      },
      child: Text("Você ainda não possui uma conta, deseja criar uma?"),
    );
  }
}
