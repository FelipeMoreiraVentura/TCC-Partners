import 'package:flutter/material.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupUserInfo extends StatefulWidget {
  const PopupUserInfo({super.key});

  @override
  State<PopupUserInfo> createState() => _PopupUserInfoState();
}

class _PopupUserInfoState extends State<PopupUserInfo> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController(text: "Felipe");
    TextEditingController email = TextEditingController(
      text: "email@gmail.com",
    );
    TextEditingController password = TextEditingController(text: "1234567890");
    TextEditingController cpfOrCnpj = TextEditingController(
      text: "1234567898765432345",
    );
    TextEditingController number = TextEditingController(text: "289275843");

    final formKey = GlobalKey<FormState>();

    return Popup(
      title: "Informações da Conta",
      actionButtons: true,
      confirmAction: () {
        if (formKey.currentState!.validate()) {
          print("firebase");
          Navigator.of(context).pop();
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ...input("Email", email, 1),
            ...input("CPF", cpfOrCnpj, 1),
            ...input("Telefone", number, 1),
            ...input("Name", userName, 1),
            ...input("Senha", password, 1),
          ],
        ),
      ),
    );
  }
}
