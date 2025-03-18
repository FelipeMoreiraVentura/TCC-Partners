import 'package:flutter/material.dart';
import 'package:market_partners/screens/login/widgets/input.dart';
import 'package:market_partners/utils/isMobile.dart';
import 'package:market_partners/utils/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int isLogin = 0;
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    double sizeBoxheigth = isLogin == 0 ? 30 : 10;
    bool isMobile = IsMobile(context);

    String email = "";
    final emailField = input("Email", (value) {
      setState(() {
        email = value;
      });
    });

    final passwordField = SizedBox(
      height: 45,
      child: TextField(
        obscureText: obscureText,
        style: AppText.tiny,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Senha",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
    );

    String cpf = "";
    final cpfField = input(isLogin == 1 ? "CPF" : "CNPJ", (value) {
      setState(() {
        cpf = value;
      });
    });

    String number = "";
    final numberField = input("Numero", (value) {
      setState(() {
        number = value;
      });
    });

    final buttonLogin = ButtonTheme(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/");
        },
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(400, 50)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        child: Text(
          isLogin != 0 ? "Login" : "Cadastrar",
          textAlign: TextAlign.center,
          style: AppText.tiny,
        ),
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
              offset: isLogin != 0 ? Offset(-15, 0) : Offset(15, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isLogin != 0
                ? isMobile
                    ? "Bem Vindo De Volta"
                    : "Bem\nVindo\nDe\nVolta"
                : isMobile
                ? "Seja Bem Vindo"
                : "Seja\nBem\nVindo",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 30 : 70,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
            ),
          ),
        ),
      );

      final loginContainer = Expanded(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
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
                  ...emailField,
                  SizedBox(height: sizeBoxheigth),
                  if (isLogin != 0) ...[
                    ...cpfField,
                    SizedBox(height: sizeBoxheigth),
                    ...numberField,
                    SizedBox(height: sizeBoxheigth),
                  ],
                  const Text("Senha"),
                  passwordField,
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin == 0 ? isLogin = 1 : isLogin = 0;
                          });
                        },
                        child: Text(
                          isLogin == 0
                              ? "Criar uma conta"
                              : "Já tenho uma conta",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      if (isLogin != 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin == 1 ? isLogin = 2 : isLogin = 1;
                            });
                          },
                          child: Text(
                            isLogin == 1 ? "Ser um vendedor" : "Ser comprador",
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
        ),
      );
      return isLogin != 0 || isMobile
          ? [text, loginContainer]
          : [loginContainer, text];
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset("images/logoString.png", height: 200, width: 200),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF024EB4), Color.fromARGB(255, 10, 45, 85)],
          ),
        ),
        child:
            isMobile ? Column(children: content()) : Row(children: content()),
      ),
    );
  }
}
