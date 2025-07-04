import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/my_filled_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int login = 0;
  bool obscureText = true;
  bool loading = false;

  TextEditingController email = TextEditingController();
  TextEditingController cpfOrCnpj = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double sizeBoxheigth = login == 0 ? 30 : 10;
    bool isMobile = IsMobile(context);

    final buttonLogin = MyFilledButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          if (login == 0) {
            // Login
            String response = await UserService().loginUser(
              email.text,
              password.text,
            );

            if (response == 'success') {
              final userDoc =
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();

              String role = userDoc.data()?['role'] ?? 'buyer';

              if (role == 'buyer') {
                Navigator.pushReplacementNamed(context, "/HomeBuyer");
              } else {
                Navigator.pushReplacementNamed(context, "/HomeSeller");
              }
            } else {
              print(response);
            }
          } else {
            // Cadastro
            if (password.text == confirmPassword.text) {
              String response = await UserService().registerUser(
                email: email.text,
                password: password.text,
                name: name.text,
                cpfOrCnpj: cpfOrCnpj.text,
                phone: phone.text,
                role: login == 1 ? 'buyer' : 'seller',
              );

              if (response == 'success') {
                if (login == 1) {
                  Navigator.pushReplacementNamed(context, "/HomeBuyer");
                } else {
                  Navigator.pushReplacementNamed(context, "/HomeSeller");
                }
              } else {
                print(response);
              }
            } else {
              print('Senhas não coincidem');
            }
          }
        }
      },
      child: Text(
        login != 0 ? "Login" : "Cadastrar",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );

    content() {
      final text = Container(
        height: isMobile ? 200 : double.infinity,
        width: isMobile ? double.infinity : 400,
        decoration: BoxDecoration(
          color: const Color.fromARGB(117, 0, 0, 0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(117, 0, 0, 0),
              blurRadius: 20,
              offset: login != 0 ? Offset(-15, 0) : Offset(15, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            login == 0
                ? isMobile
                    ? "Bem Vindo De Volta"
                    : "Bem\nVindo\nDe\nVolta"
                : isMobile
                ? "Bem Vindo ao Futuro"
                : "Bem\nVindo\nao\nFuturo",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 30 : 70,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
            ),
          ),
        ),
      );

      final loginContainer = Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(-10, 10),
                ),
              ],
            ),
            width: 400,
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sizeBoxheigth),
                Input(type: "Email", controller: email, validation: true),
                SizedBox(height: sizeBoxheigth),
                if (login != 0) ...[
                  Input(
                    type: login == 1 ? "CPF" : "CNPJ",
                    controller: cpfOrCnpj,
                    validation: true,
                  ),
                  SizedBox(height: sizeBoxheigth),
                  Input(type: "Telefone", controller: phone, validation: true),
                  SizedBox(height: sizeBoxheigth),
                  Input(type: "Nome", controller: name, validation: true),
                ],
                Input(type: "Senha", controller: password, validation: true),
                if (login != 0)
                  Input(
                    type: "Confirmar Senha",
                    controller: confirmPassword,
                    validation: true,
                  ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login == 0 ? login = 1 : login = 0;
                        });
                      },
                      child: Text(
                        login == 0 ? "Criar uma conta" : "Já tenho uma conta",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    if (login != 0)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            login == 1 ? login = 2 : login = 1;
                            cpfOrCnpj.clear();
                          });
                        },
                        child: Text(
                          login == 1 ? "Ser um vendedor" : "Ser comprador",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 30),
                buttonLogin,
              ],
            ),
          ),
        ),
      );
      return login != 0 || isMobile
          ? [text, Expanded(child: loginContainer)]
          : [Expanded(child: loginContainer), text];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/images/logoString.png",
          height: 200,
          width: 200,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue, Color.fromARGB(255, 10, 45, 85)],
          ),
        ),
        child: Form(
          key: formKey,
          child:
              isMobile ? Column(children: content()) : Row(children: content()),
        ),
      ),
    );
  }
}
