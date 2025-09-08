import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_partners/router/app_router.dart';
import 'package:market_partners/utils/go_or_push_named.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/popup_create_account.dart';
import 'package:market_partners/widgets/widgetsChat.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;

  bool chatView = false;

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    final currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();

    List<Widget> buttonRoutes = [
      IconButton(
        onPressed:
            currentRoute == "/HomeBuyer"
                ? null
                : () {
                  navNamed(context, AppRoute.homeBuyer);
                },
        icon: Icon(
          Icons.home_filled,
          color: currentRoute == "/HomeBuyer" ? Colors.grey : AppColors.blue,
          size: 40,
        ),
      ),
      IconButton(
        onPressed:
            currentRoute == "/history"
                ? null
                : () {
                  if (user != null) {
                    navNamed(context, AppRoute.history);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PopupCreateAccount();
                      },
                    );
                  }
                },
        icon: Icon(
          Icons.history,
          color: currentRoute == "/history" ? Colors.grey : AppColors.blue,
          size: 40,
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            chatView = !chatView;
          });
        },
        child: Image.asset("assets/images/chatIcon.png", width: 45, height: 45),
      ),
    ];

    IconButton configButton = IconButton(
      onPressed:
          currentRoute == "/configuration"
              ? null
              : () {
                if (user != null) {
                  navNamed(context, AppRoute.configuration);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PopupCreateAccount();
                    },
                  );
                }
              },
      icon: Icon(
        Icons.account_circle,
        color: currentRoute == "/configuration" ? Colors.grey : AppColors.blue,
        size: 40,
      ),
    );

    Positioned viewChatMenu = Positioned(
      child: Opacity(
        opacity: chatView ? 1.0 : 0,
        child: AnimatedSlide(
          duration: Duration(milliseconds: 200),
          offset:
              chatView
                  ? Offset.zero
                  : isMobile
                  ? Offset(0, 1.0)
                  : Offset(-1.0, 0),
          child: ChatView(),
        ),
      ),
    );

    return isMobile
        ? Column(
          children: [
            Expanded(child: Stack(children: [widget.child, viewChatMenu])),
            Container(
              color: AppColors.menu,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [...buttonRoutes, configButton],
              ),
            ),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.menu,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Column(children: buttonRoutes), configButton],
              ),
            ),
            Expanded(child: Stack(children: [widget.child, viewChatMenu])),
          ],
        );
  }
}
