import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/widgetsChat.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool chatView = false;

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    List<Widget> buttonRoutes = [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/delivery");
        },
        icon: Icon(Icons.shopping_bag_sharp, color: AppColors.blue, size: 40),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/history");
        },
        icon: Icon(Icons.history, color: AppColors.blue, size: 40),
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
      onPressed: () {
        Navigator.pushNamed(context, "/configuration");
      },
      icon: Icon(Icons.account_circle, color: AppColors.blue, size: 40),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body:
          isMobile
              ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: widget.child,
                          ),
                        ),
                        if (chatView)
                          Positioned(bottom: 0, right: 0, child: ChatView()),
                      ],
                    ),
                  ),
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
                    margin: EdgeInsets.only(bottom: 10),
                    color: AppColors.menu,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Column(children: buttonRoutes), configButton],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: widget.child,
                          ),
                        ),
                        if (chatView) Positioned(child: ChatView()),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
