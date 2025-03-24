import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

List<Widget> input(String type, controller) {
  String hintText =
      type == "Email"
          ? "Named@Example.com"
          : type == "CPF" || type == "CNPJ"
          ? "000.000.000-00"
          : type == "Numero"
          ? "(00) 00000-0000"
          : type;

  final maskFormatter = MaskTextInputFormatter(
    mask: type == "CPF" ? "###.###.###-##" : "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')},
  );

  return [
    Text(type),
    SizedBox(
      height: 45,
      child: TextField(
        obscureText: false,
        style: AppText.md,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        ),
        controller: controller,
        inputFormatters:
            type == "CPF" || type == "Numero" || type == "CNPJ"
                ? [maskFormatter]
                : [],
      ),
    ),
  ];
}
