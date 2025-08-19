import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/user.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/screens/buyer/configurations/widget/popup_adress_info.dart';
import 'package:market_partners/screens/buyer/configurations/widget/popup_user_info.dart';
import 'package:market_partners/screens/buyer/configurations/widget/select_language.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/not_logged_navigator.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/nav_bar.dart';
import 'package:market_partners/widgets/popup.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  String role = "buyer";
  User? user;
  UserInformation? userInformation;

  @override
  void initState() {
    super.initState();
    loadingUser();
  }

  loadingUser() async {
    user = FirebaseAuth.instance.currentUser;
    role = await UserService().getRole(user!.uid);
    final info = await UserService().getInfo(user!.uid);
    setState(() {
      userInformation = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    notLoggedNavigator(context, user);

    bool isMobile = IsMobile(context);

    PopupUserInfo popupUserInfo = PopupUserInfo(
      userInformation: userInformation,
    );
    PopupAdressInfo popupAddressInfo = PopupAdressInfo();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: backAppbar("Configurações"),
      body: NavBar(
        child:
            userInformation == null
                ? widgetLoading()
                : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(child: Icon(Icons.account_circle, size: 200)),
                      TranslatedText(
                        text: userInformation!.name,
                        style: AppText.md,
                      ),
                      TranslatedText(text: userInformation!.email),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AppColors.menu,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 0.2,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 100,
                        ),
                        child: Column(
                          children: [
                            if (role == "seller")
                              ListTile(
                                splashColor: Colors.grey,
                                title: TranslatedText(
                                  text: "Ir Para Tela de vendedor",
                                ),
                                leading: Icon(
                                  Icons.sell_sharp,
                                  size: 40,
                                  color: AppColors.blue,
                                ),
                                onTap: () {
                                  context.goNamed(AppRoute.homeSeller);
                                },
                              ),
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return popupUserInfo;
                                  },
                                );
                              },
                              splashColor: Colors.grey,
                              title: TranslatedText(text: "Dados da conta"),
                              subtitle: TranslatedText(
                                text: "Nome, Email, CPF, telefone e senha",
                              ),
                              leading: Icon(
                                Icons.account_circle,
                                size: 40,
                                color: AppColors.blue,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return popupAddressInfo;
                                  },
                                );
                              },
                              title: TranslatedText(text: "Endereço"),
                              subtitle: TranslatedText(
                                text: "Localizações de entrega",
                              ),
                              leading: Icon(
                                Icons.location_on,
                                size: 40,
                                color: AppColors.blue,
                              ),
                            ),
                            ListTile(
                              title: TranslatedText(text: "Sobre PartnersBot"),
                              subtitle: TranslatedText(
                                text: "Saiba mais de nossa IA !",
                              ),
                              onTap: () {
                                context.pushNamed(AppRoute.partnersBot);
                              },
                              leading: Image.asset(
                                "assets/images/chatIcon.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            ListTile(
                              title: TranslatedText(text: "Logout"),
                              subtitle: TranslatedText(text: "Sair da conta"),
                              leading: Icon(
                                Icons.logout_sharp,
                                size: 40,
                                color: AppColors.blue,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => Popup(
                                        title: "Logout",
                                        actionButtons: true,
                                        confirmAction: () {
                                          UserService().logout();
                                          context.goNamed(AppRoute.login);
                                        },
                                        child: TranslatedText(
                                          text: "Deseja sair da conta?",
                                          style: AppText.base,
                                        ),
                                      ),
                                );
                              },
                            ),
                            SelectLanguage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
