import 'dart:convert';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:market_partners/device/api.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/card_product.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:market_partners/utils/global.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool loadingResp = false;
  final ScrollController _scrollController = ScrollController();

  bool isListening = false;

  Uint8List? imageFile;
  final speech = stt.SpeechToText();

  final TextEditingController promptController = TextEditingController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage(prompt) async {
    if (prompt == "") return;

    setState(() {
      chatHistory.add({
        "sender": "user",
        "message": prompt,
        "image": imageFile,
      });
    });
    _scrollToBottom();

    setState(() {
      loadingResp = true;
    });

    Response dataChat = await Api.post("/chat", {
      "prompt": prompt,
      "image": imageFile != null ? base64Encode(imageFile!) : "",
      "history": chatHistoryText,
    });

    setState(() {
      loadingResp = false;
    });
    if (dataChat.statusCode == 200) {
      final responseBody = utf8.decode(dataChat.bodyBytes);
      final dynamic jsonResponse = jsonDecode(responseBody);

      final String chatResponse =
          jsonResponse is Map
              ? jsonResponse['output'] ?? responseBody
              : responseBody;

      final List<dynamic>? products =
          jsonResponse is Map && jsonResponse.containsKey('products')
              ? jsonResponse["products"]
              : null;

      if (jsonResponse is Map && jsonResponse.containsKey('history')) {
        chatHistoryText = jsonResponse['history'] ?? chatHistoryText;
      }

      setState(() {
        chatHistory.add({
          "sender": "bot",
          "message": chatResponse,
          "products": products,
        });
      });
    } else {
      setState(() {
        chatHistory.add({"sender": "bot", "message": "Ocorreu algum erro: "});
      });
    }

    _scrollToBottom();

    setState(() {
      imageFile = null;
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
      color: AppColors.menuBackground,
      width: isMobile ? mediaQueryWidht : mediaQueryWidht * 0.35,
      height: mediaQueryHeight,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("PartnersBot", style: AppText.titleMedium),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> message = chatHistory[index];
                bool isUser = message["sender"] == "user";
                String sender = isUser ? "Você" : "PartnersBot";
                String text = message["message"] as String;
                Uint8List? image = message["image"] as Uint8List?;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sender, style: AppText.sm),
                      const SizedBox(height: 4),
                      Text(text, softWrap: true),
                      if (image != null && isUser)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Image.memory(image, width: 200),
                        ),
                      if (message.containsKey("products") &&
                          message["products"] != null)
                        SizedBox(
                          height: 200,
                          child: CarouselSlider(
                            items:
                                (message["products"] as List).map<Widget>((
                                  productData,
                                ) {
                                  final product = ProductModel.fromJson(
                                    productData,
                                  );
                                  return CardProduct(product: product);
                                }).toList(),
                            options: CarouselOptions(
                              height: 200,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.5,
                              padEnds: false,
                            ),
                          ),
                        ),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
          if (loadingResp)
            widgetLoading(
              height: 10,
              width: double.infinity,
              verticalPadding: 0,
              horizontalPadding: 0,
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
