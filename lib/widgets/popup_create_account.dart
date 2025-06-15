import 'package:flutter/material.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupCreateAccount extends StatelessWidget {
  const PopupCreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Popup(
      title: "Criar Conta",
      actionButtons: true,
      confirmAction: () {
        Navigator.pushNamed(context, "/login");
      },
      child: Text("Você ainda não possui uma conta, deseja criar uma?"),
    );
  }
}
