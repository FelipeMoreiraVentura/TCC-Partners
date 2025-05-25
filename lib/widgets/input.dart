import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

List<Widget> input(String type, controller, login) {
  String? emailValidation(value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Insira um email válido';
    }
    return null;
  }

  String? phoneValidation(value) {
    final phoneRegex = RegExp(r'^\([1-9]{2}\)\s9[0-9]{4}-[0-9]{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Insira um número válido';
    }
    return null;
  }

  String? cpfOrCnpjValidation(value) {
    bool validation =
        type == "CPF"
            ? !CPFValidator.isValid(value)
            : !CNPJValidator.isValid(value);

    if (validation) {
      return 'Insira um $type válido';
    }
    return null;
  }

  String hintText =
      type == "Email"
          ? "Named@Example.com"
          : type == "CPF"
          ? "000.000.000-00"
          : type == "CNPJ"
          ? "00.000.000/0000-00"
          : type == "Telefone"
          ? "(00) 00000-0000"
          : type;

  final maskFormatter = MaskTextInputFormatter(
    mask:
        type == "CPF"
            ? "###.###.###-##"
            : type == "CNPJ"
            ? "##.###.###/####-##"
            : "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')},
  );

  return [
    Text(type),
    SizedBox(
      height: 60,
      child: TextFormField(
        obscureText: false,
        style: AppText.md,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          helperText: "",
        ),
        controller: controller,
        inputFormatters:
            type == "CPF" || type == "Telefone" || type == "CNPJ"
                ? [maskFormatter]
                : [],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Preencha este campo';
          }
          return login == 0
              ? null
              : type == "Email"
              ? emailValidation(value)
              : type == "Telefone"
              ? phoneValidation(value)
              : type == "CPF" || type == "CNPJ"
              ? cpfOrCnpjValidation(value)
              : null;
        },
      ),
    ),
  ];
}
