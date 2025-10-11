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
          duration: const Duration(milliseconds: 300),
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
        chatHistory.add({"sender": "bot", "message": "Ocorreu algum erro."});
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
                String text = message["message"] as String;
                Uint8List? image = message["image"] as Uint8List?;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFFDCF8C6)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUser
                                  ? const Radius.circular(16)
                                  : const Radius.circular(0),
                              bottomRight: isUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: const TextStyle(fontSize: 15),
                              ),
                              if (image != null && isUser)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      image,
                                      width: 150,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (message.containsKey("products") &&
                            message["products"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
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
                          ),
                      ],
                    ),
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
            color: const Color.fromARGB(255, 240, 240, 240),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                if (imageFile != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.memory(imageFile!, width: 40, height: 40),
                  ),
                IconButton(
                  onPressed: () async {
                    Uint8List? getImage = await pickImage();
                    if (getImage != null) {
                      setState(() {
                        imageFile = getImage;
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                ),
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: const InputDecoration(
                      hintText: "Digite sua mensagem...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value);
                      promptController.clear();
                    },
                  ),
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
                IconButton(
                  onPressed: () {
                    sendMessage(promptController.text);
                    promptController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
