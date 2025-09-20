import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum InputType {
  email,
  cpf,
  cnpj,
  telefone,
  cep,
  senha,
  confirmarSenha,
  doubleType,
  intType,
  text,
}

class Input extends StatefulWidget {
  final InputType type;
  final String? label;
  final TextEditingController controller;
  final bool validation;
  final bool multiline;

  const Input({
    super.key,
    required this.type,
    required this.controller,
    required this.validation,
    this.label,
    this.multiline = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _obscureText = true;

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
          widget.type == InputType.cpf
              ? !CPFValidator.isValid(value)
              : !CNPJValidator.isValid(value);

      if (validation) {
        return 'Insira um ${widget.type.name.toUpperCase()} válido';
      }
      return null;
    }

    String? passwordValidation(value) {
      if (value.length < 6) {
        return 'A senha deve ter pelo menos 6 caracteres';
      }
      return null;
    }

    String? cepValidation(value) {
      final cepRegex = RegExp(r'^\d{5}-\d{3}$');
      if (!cepRegex.hasMatch(value)) {
        return 'Insira um CEP válido';
      }
      return null;
    }

    String? doubleValidation(value) {
      final doubleRegex = RegExp(r'^\d+(\.\d+)?$');
      if (!doubleRegex.hasMatch(value.replaceAll(',', '.'))) {
        return 'Insira um número válido';
      }
      return null;
    }

    String? intValidation(value) {
      final intRegex = RegExp(r'^\d+$');
      if (!intRegex.hasMatch(value)) {
        return 'Insira um número inteiro válido';
      }
      return null;
    }

    String hintText =
        widget.type == InputType.email
            ? "Named@Example.com"
            : widget.type == InputType.cpf
            ? "000.000.000-00"
            : widget.type == InputType.cnpj
            ? "00.000.000/0000-00"
            : widget.type == InputType.telefone
            ? "(00) 00000-0000"
            : widget.type == InputType.cep
            ? "00000-000"
            : widget.type == InputType.senha ||
                widget.type == InputType.confirmarSenha
            ? "****"
            : widget.type == InputType.intType
            ? "123"
            : widget.type == InputType.doubleType
            ? "1.23"
            : "";

    final maskFormatter =
        widget.type == InputType.cpf
            ? MaskTextInputFormatter(
              mask: "###.###.###-##",
              filter: {"#": RegExp(r'[0-9]')},
            )
            : widget.type == InputType.cnpj
            ? MaskTextInputFormatter(
              mask: "##.###.###/####-##",
              filter: {"#": RegExp(r'[0-9]')},
            )
            : widget.type == InputType.telefone
            ? MaskTextInputFormatter(
              mask: "(##) #####-####",
              filter: {"#": RegExp(r'[0-9]')},
            )
            : widget.type == InputType.cep
            ? MaskTextInputFormatter(
              mask: "#####-###",
              filter: {"#": RegExp(r'[0-9]')},
            )
            : widget.type == InputType.intType
            ? MaskTextInputFormatter(
              mask: "########################################",
              filter: {"#": RegExp(r'[0-9]')},
            )
            : widget.type == InputType.doubleType
            ? MaskTextInputFormatter(
              mask: "########################################",
              filter: {"#": RegExp(r'[0-9.,]')},
            )
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(text: widget.label ?? widget.type.name),
        SizedBox(
          height: widget.multiline ? null : 60,
          width: double.infinity,
          child: TextFormField(
            obscureText:
                widget.type == InputType.senha ||
                        widget.type == InputType.confirmarSenha
                    ? _obscureText
                    : false,
            style: AppText.md,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.blue, width: 2),
              ),
              helperText: "",
              suffixIcon:
                  widget.type == InputType.senha ||
                          widget.type == InputType.confirmarSenha
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                      : null,
            ),
            controller: widget.controller,
            keyboardType:
                widget.multiline
                    ? TextInputType.multiline
                    : widget.type == InputType.doubleType
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : widget.type == InputType.intType
                    ? TextInputType.number
                    : TextInputType.text,
            maxLines: widget.multiline ? null : 1,
            inputFormatters: maskFormatter != null ? [maskFormatter] : [],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha este campo';
              }

              if (!widget.validation) return null;

              switch (widget.type) {
                case InputType.email:
                  return emailValidation(value);
                case InputType.telefone:
                  return phoneValidation(value);
                case InputType.cpf:
                case InputType.cnpj:
                  return cpfOrCnpjValidation(value);
                case InputType.senha:
                case InputType.confirmarSenha:
                  return passwordValidation(value);
                case InputType.cep:
                  return cepValidation(value);
                case InputType.doubleType:
                  return doubleValidation(value);
                case InputType.intType:
                  return intValidation(value);
                default:
                  return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
