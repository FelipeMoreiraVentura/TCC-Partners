import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Input extends StatefulWidget {
  final String type;
  final TextEditingController controller;
  final bool validation;

  const Input({
    super.key,
    required this.type,
    required this.controller,
    required this.validation,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
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
          widget.type == "CPF"
              ? !CPFValidator.isValid(value)
              : !CNPJValidator.isValid(value);

      if (validation) {
        return 'Insira um ${widget.type} válido';
      }
      return null;
    }

    String hintText =
        widget.type == "Email"
            ? "Named@Example.com"
            : widget.type == "CPF"
            ? "000.000.000-00"
            : widget.type == "CNPJ"
            ? "00.000.000/0000-00"
            : widget.type == "Telefone"
            ? "(00) 00000-0000"
            : widget.type;

    final maskFormatter = MaskTextInputFormatter(
      mask:
          widget.type == "CPF"
              ? "###.###.###-##"
              : widget.type == "CNPJ"
              ? "##.###.###/####-##"
              : "(##) #####-####",
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.type),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: TextFormField(
            obscureText: false,
            style: AppText.md,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              helperText: "",
            ),
            controller: widget.controller,
            inputFormatters:
                widget.type == "CPF" ||
                        widget.type == "Telefone" ||
                        widget.type == "CNPJ"
                    ? [maskFormatter]
                    : [],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha este campo';
              }
              return !widget.validation
                  ? null
                  : widget.type == "Email"
                  ? emailValidation(value)
                  : widget.type == "Telefone"
                  ? phoneValidation(value)
                  : widget.type == "CPF" || widget.type == "CNPJ"
                  ? cpfOrCnpjValidation(value)
                  : null;
            },
          ),
        ),
      ],
    );
  }
}
