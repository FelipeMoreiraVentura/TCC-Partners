import 'package:flutter/material.dart';
import 'package:market_partners/utils/isMobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/widgetsChat.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool chatView = true;

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    List<Widget> buttonRoutes = [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.settings, color: AppColors.blue, size: 40),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.shopping_bag_sharp, color: AppColors.blue, size: 40),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.history, color: AppColors.blue, size: 40),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            chatView = !chatView;
          });
        },
        child: Image.asset("images/chatIcon.png", width: 45, height: 45),
      ),
    ];

    return isMobile
        ? Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  widget.child,
                  if (chatView) Positioned(bottom: 0, child: ChatView()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonRoutes,
            ),
          ],
        )
        : Row(
          children: [
            Column(children: buttonRoutes),
            Expanded(
              child: Stack(
                children: [
                  widget.child,
                  if (chatView) Positioned(child: ChatView()),
                ],
              ),
            ),
          ],
        );
  }
}
