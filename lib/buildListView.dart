import 'package:flutter/material.dart';

class buildlistview extends StatefulWidget {
  const buildlistview({super.key});

  @override
  State<buildlistview> createState() => _buildlistviewState();
}

class _buildlistviewState extends State<buildlistview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista ")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.add_location),
            title: Text("Text"),
            subtitle: Text("subtítulo"),
            trailing: Icon(Icons.add_shopping_cart),
            onTap: () => print("idvfhyrdtsAGSWJPOI5E"),
          ),
          ListTile(
            leading: Icon(Icons.add_location),
            title: Text("Text"),
            subtitle: Text("subtítulo"),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_shopping_cart),
            ),
          ),
          Text("Exemplo"),
          Container(color: Colors.green, height: 60),
        ],
      ),
    );
  }
}
