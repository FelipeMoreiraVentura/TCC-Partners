import 'package:flutter/material.dart';

class Terceira extends StatefulWidget {
  const Terceira({super.key});

  @override
  State<Terceira> createState() => _TerceiraState();
}

class _TerceiraState extends State<Terceira> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/");
              },
              child: Text("home"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text("login"),
            ),
          ],
        ),
      ),
    );
  }
}
