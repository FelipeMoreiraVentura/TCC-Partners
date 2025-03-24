import 'package:flutter/material.dart';
import 'package:market_partners/utils/isMobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, String>> chatHistory = [];
  bool isListening = false;
  final speech = stt.SpeechToText();
  final TextEditingController promptController = TextEditingController();

  void sendMessage(prompt) {
    setState(() {
      chatHistory.add({"sender": "user", "message": prompt});
      chatHistory.add({
        "sender": "bot",
        "message": "Bom dia, como posso ajudar?",
      });
    });
  }

  void listen() async {
    if (isListening) {
      bool available = await speech.initialize(
        onStatus: (status) {
          setState(() {
            isListening = status == "listening";
          });
        },
        onError: (error) {
          setState(() {
            isListening = false;
          });
        },
      );

      if (available) {
        speech.listen(
          onResult: (result) {
            setState(() {
              promptController.text = result.recognizedWords;
            });
          },
          localeId: 'pt_BR',
        );
      }
    } else {
      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    double mediaQueryWidht = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

    return Container(
      color: AppColors.menu,
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
                TextField(
                  controller: promptController,
                  onSubmitted: (value) {
                    sendMessage(value);
                    promptController.clear();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isListening = !isListening;
                            });
                            listen();
                          },
                          icon: Icon(
                            Icons.mic,
                            color: isListening ? Colors.red : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(promptController.text);
                        promptController.clear();
                      },
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
