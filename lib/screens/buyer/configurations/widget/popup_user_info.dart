// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/models/user.dart';
import 'package:market_partners/utils/toast.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/popup.dart';
import 'package:market_partners/firebase/user.dart';

class PopupUserInfo extends StatefulWidget {
  final UserInformation? userInformation;

  const PopupUserInfo({super.key, required this.userInformation});

  @override
  State<PopupUserInfo> createState() => _PopupUserInfoState();
}

class _PopupUserInfoState extends State<PopupUserInfo> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isEditing = false;
  String editMode = "none"; // "none", "phone", "password"

  @override
  void initState() {
    super.initState();
    if (widget.userInformation != null) {
      phoneController.text = widget.userInformation!.phone;
    }
  }

  Future<void> _updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (user == null || user!.email == null) return;

    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword,
    );

    await user!.reauthenticateWithCredential(credential);
    await user!.updatePassword(newPassword);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Popup(
      title: "Informações da Conta",
      actionButtons: true,
      labelCloseButton: "Fechar",
      labelConfirButton: isEditing ? "Confirmar" : "Editar",
      confirmAction: () async {
        if (!isEditing) {
          setState(() {
            isEditing = true;
            editMode = "none";
          });
          return;
        }

        if (editMode == "phone") {
          if (phoneController.text.isNotEmpty &&
              widget.userInformation != null) {
            final updatedUser = UserInformation(
              uid: widget.userInformation!.uid,
              name: widget.userInformation!.name,
              email: widget.userInformation!.email,
              phone: phoneController.text,
              role: widget.userInformation!.role,
              cpfOrCnpj: widget.userInformation!.cpfOrCnpj,
              createdAt: widget.userInformation!.createdAt,
            );
            await UserService().updateUserInfo(updatedUser);
            ToastService.success("Número atualizado com sucesso!");
          }
        }

        if (editMode == "password") {
          final currentPassword = currentPasswordController.text.trim();
          final newPassword = passwordController.text.trim();
          final confirmPassword = confirmPasswordController.text.trim();

          if (currentPassword.isEmpty ||
              newPassword.isEmpty ||
              confirmPassword.isEmpty) {
            ToastService.error("Preencha todos os campos de senha.");
            return;
          }

          if (newPassword != confirmPassword) {
            ToastService.error("As senhas não coincidem.");
            return;
          }

          try {
            await _updatePassword(currentPassword, newPassword);
            ToastService.success("Senha atualizada com sucesso");
          } catch (e) {
            ToastService.error("Erro ao atualizar senha: $e");
            return;
          }
        }

        setState(() {
          isEditing = false;
          editMode = "none";
        });

        Navigator.of(context).pop();
      },
      child:
          widget.userInformation == null
              ? widgetLoading()
              : Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isEditing) ...[
                      Text("Email: ${widget.userInformation!.email}"),
                      Text("Nome: ${widget.userInformation!.name}"),
                      Text("CPF/CNPJ: ${widget.userInformation!.cpfOrCnpj}"),
                      Text("Telefone: ${widget.userInformation!.phone}"),
                    ] else if (editMode == "none") ...[
                      Text(
                        "O que você deseja editar?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => editMode = "phone"),
                        icon: Icon(Icons.phone),
                        label: Text("Editar Telefone"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => editMode = "password"),
                        icon: Icon(Icons.lock),
                        label: Text("Alterar Senha"),
                      ),
                    ] else if (editMode == "phone") ...[
                      Input(
                        label: "Novo Telefone",
                        type: InputType.telefone,
                        controller: phoneController,
                        validation: true,
                      ),
                    ] else if (editMode == "password") ...[
                      Input(
                        label: "Senha Atual",
                        type: InputType.senha,
                        controller: currentPasswordController,
                        validation: true,
                      ),
                      const SizedBox(height: 10),
                      Input(
                        label: "Nova Senha",
                        type: InputType.senha,
                        controller: passwordController,
                        validation: true,
                      ),
                      const SizedBox(height: 10),
                      Input(
                        label: "Confirmar Nova Senha",
                        type: InputType.senha,
                        controller: confirmPasswordController,
                        validation: true,
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
