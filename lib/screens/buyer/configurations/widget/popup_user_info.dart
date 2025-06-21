import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/models/user.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupUserInfo extends StatefulWidget {
  final UserInformation? userInformation;

  const PopupUserInfo({super.key, required this.userInformation});

  @override
  State<PopupUserInfo> createState() => _PopupUserInfoState();
}

class _PopupUserInfoState extends State<PopupUserInfo> {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController password = TextEditingController(text: "");
  TextEditingController number = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Popup(
      title: "Informações da Conta",
      actionButtons: true,
      confirmAction: () {
        if (formKey.currentState!.validate()) {
          Navigator.of(context).pop();
        }
      },
      child:
          widget.userInformation == null
              ? widgetLoading()
              : Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(widget.userInformation!.email),
                    Text(widget.userInformation!.cpfOrCnpj),
                    Input(
                      type: "Telefone",
                      controller: number,
                      validation: true,
                    ),
                    Text(widget.userInformation!.name),
                    Input(
                      type: "Senha",
                      controller: password,
                      validation: true,
                    ),
                  ],
                ),
              ),
    );
  }
}
