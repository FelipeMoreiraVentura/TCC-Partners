import 'package:flutter/material.dart';
import 'package:market_partners/utils/isMobile.dart';
import 'package:market_partners/utils/style.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> chatHistory = [
      {"sender": "bot", "message": "Olá, como posso te ajudar hoje?"},
      {
        "sender": "user",
        "message": "Bom dia, meu celular não está carregando mais.",
      },
      {
        "sender": "bot",
        "message":
            "Certo. Inicialmente, tente identificar o culpado: troque o cabo, a fonte que está usando e, se possível, teste o carregador em outro aparelho.",
      },
      {"sender": "user", "message": "O que é fonte?"},
      {
        "sender": "bot",
        "message": "Fonte é a parte do carregador que você conecta na tomada.",
      },
      {"sender": "user", "message": "Certo, o problema é no cabo."},
      {
        "sender": "bot",
        "message":
            "Ótimo, encontramos o problema. Agora precisamos saber qual é o tipo do seu conector. Observe a parte que você conecta ao dispositivo e me diga qual o formato.",
      },
      {
        "sender": "user",
        "message": "Ele, é retangular com bordas arredondadas ",
      },
      {
        "sender": "bot",
        "message":
            "Isso é caracteristicas de um conector tipo-c, Veja o modelo abaixo:",
      },
    ];

    bool isMobile = IsMobile(context);

    double mediaQueryWidht = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 187, 186, 186),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
      ),
      width: isMobile ? mediaQueryWidht : mediaQueryWidht * 0.35,
      height: isMobile ? mediaQueryHeight * 0.6 : mediaQueryHeight,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("PartnersBot", style: AppText.titleMedium),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                Map<String, String> message = chatHistory[index];
                bool isUser = message["sender"] == "user";
                String sender = isUser ? "Você" : "PartnersBot";
                String text = message["message"] as String;
                return ListTile(
                  title: Text(sender),
                  subtitle: Text(text),
                  leading: isUser ? null : Icon(Icons.chat),
                );
              },
            ),
          ),
          Container(
            height: 100,
            color: const Color.fromARGB(255, 207, 205, 205),
            child: Column(
              children: [
                TextField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
