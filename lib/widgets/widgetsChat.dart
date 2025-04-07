import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, dynamic>> chatHistory = [];
  bool isListening = false;

  Uint8List? imageFile;
  final speech = stt.SpeechToText();

  final TextEditingController promptController = TextEditingController();

  void sendMessage(prompt) {
    if (prompt == "") return;
    setState(() {
      chatHistory.add({
        "sender": "user",
        "message": prompt,
        "image": imageFile,
      });
      chatHistory.add({
        "sender": "bot",
        "message": "Bom dia! Como posso ajudar você?",
      });
      setState(() {
        imageFile = null;
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
      color: const Color.fromARGB(255, 179, 178, 178),
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
                Map<String, dynamic> message = chatHistory[index];
                bool isUser = message["sender"] == "user";
                String sender = isUser ? "Você" : "PartnersBot";
                String text = message["message"] as String;
                Uint8List? image = message["image"] as Uint8List?;
                return ListTile(
                  title: Text(sender),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, softWrap: true),
                      if (image != null && isUser)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Image.memory(image, width: 200),
                        ),
                    ],
                  ),
                  leading: isUser ? null : Icon(Icons.chat),
                  isThreeLine: true,
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
                        if (imageFile != null)
                          Image.memory(imageFile!, width: 50, height: 50),
                        IconButton(
                          onPressed: () async {
                            Uint8List? getImage = await pickImage();
                            if (getImage != null) {
                              setState(() {
                                imageFile = getImage;
                              });
                            }
                          },
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
