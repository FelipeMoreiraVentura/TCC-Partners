import 'package:flutter/material.dart';

class CorPreferida extends StatefulWidget {
  const CorPreferida({super.key});

  @override
  State<CorPreferida> createState() => _CorPreferidaState();
}

class _CorPreferidaState extends State<CorPreferida> {
  String cor = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cor preferida")),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            height: 60,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onSubmitted:
                  (value) => setState(() {
                    cor = value;
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "sua cor preferida é $cor",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
