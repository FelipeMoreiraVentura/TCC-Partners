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

    // Reautentica antes de atualizar senha
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
      confirmAction:
          !isEditing
              ? () {
                setState(() {
                  isEditing = true;
                });
              }
              : () async {
                if (formKey.currentState!.validate()) {
                  final currentPassword = currentPasswordController.text.trim();
                  final newPassword = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (newPassword.isNotEmpty &&
                      newPassword != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("As senhas não coincidem")),
                    );
                    return;
                  }

                  if (widget.userInformation != null) {
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
                  }

                  if (newPassword.isNotEmpty && currentPassword.isNotEmpty) {
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
                  });

                  Navigator.of(context).pop();
                }
              },
      child:
          widget.userInformation == null
              ? widgetLoading()
              : Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      !isEditing
                          ? [
                            Text("Email: ${widget.userInformation!.email}"),
                            Text("Nome: ${widget.userInformation!.name}"),
                            Text(
                              "CPF/CNPJ: ${widget.userInformation!.cpfOrCnpj}",
                            ),
                            Text("Telefone: ${widget.userInformation!.phone}"),
                          ]
                          : [
                            Input(
                              label: "Telefone",
                              type: InputType.telefone,
                              controller: phoneController,
                              validation: true,
                            ),
                            Input(
                              label: "Senha Atual",
                              type: InputType.senha,
                              controller: currentPasswordController,
                              validation: false,
                            ),
                            Input(
                              label: "Nova Senha",
                              type: InputType.senha,
                              controller: passwordController,
                              validation: false,
                            ),
                            Input(
                              label: "Confirmar Nova Senha",
                              type: InputType.senha,
                              controller: confirmPasswordController,
                              validation: false,
                            ),
                          ],
                ),
              ),
    );
  }
}
