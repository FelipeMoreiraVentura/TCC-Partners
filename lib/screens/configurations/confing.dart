import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class Confing extends StatelessWidget {
  const Confing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Configurações",
          style: AppText.lg.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.blue,
      ),
      body: Column(
        children: [
          Center(child: Icon(Icons.account_circle, size: 200)),
          Text("Nome", style: AppText.md),
          Text("Exemplo@Email.com"),
          SizedBox(height: 30),
          Expanded(
            child: Center(
              child: ListView(
                children: [
                  ListTile(
                    splashColor: Colors.grey,
                    title: Text("Dados da conta"),
                    subtitle: Text("Nome, Email, telefone e senha"),
                    leading: Icon(Icons.account_circle, size: 40),
                  ),
                  ListTile(
                    title: Text("Enderedeço"),
                    subtitle: Text("Localizações de entrega"),
                    leading: Icon(Icons.location_on, size: 40),
                  ),
                  ListTile(
                    title: Text("Dados Pessoais"),
                    subtitle: Text("RG e CPF"),
                    leading: Icon(Icons.perm_identity, size: 40),
                  ),
                  ListTile(
                    title: Text("Sobre PartnersBot"),
                    subtitle: Text("Saiba mais de nossa IA !"),
                    leading: Image.asset(
                      "assets/images/chatIcon.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
