import 'package:flutter/material.dart';

class Buildlistview2 extends StatefulWidget {
  const Buildlistview2({super.key});

  @override
  State<Buildlistview2> createState() => _Buildlistview2State();
}

class _Buildlistview2State extends State<Buildlistview2> {
  @override
  Widget build(BuildContext context) {
    // final itens = List<String>.generate(1000, (i) => "Item $i");

    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Itens")), // Adiciona um AppBar
      body: ListView.builder(
        // itemCount: itens.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.arrow_left),
            title: Text("linha $index"),
            onTap: () {
              debugPrint("$index");
            }, // Corrigida a interpolação
          );
        },
      ),
    );
  }
}
