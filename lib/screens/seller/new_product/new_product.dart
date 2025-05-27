import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:market_partners/screens/seller/new_product/widget/carousel_image.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';

import '../../../device/api.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  bool isLoading = false;

  List<Map<String, dynamic>> imagesPrev = [];
  List<Uint8List> images = [];

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  identifyImage() async {
    if (images.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      final imagemBase64 = base64Encode(images[0]);
      Response data = await Api.post("identify_image", {"image": imagemBase64});
      if (data.statusCode == 200) {
        setState(() {
          final List<dynamic> parsedList = jsonDecode(
            utf8.decode(data.bodyBytes),
          );
          imagesPrev = parsedList.cast<Map<String, dynamic>>();

          isLoading = false;
        });
      }
    }
  }

  setText(product) async {
    setState(() {
      isLoading = true;
    });
    Response data = await Api.post("set_product", {"product": product});
    if (data.statusCode == 200) {
      setState(() {
        Map<String, dynamic> infoJson = jsonDecode(data.body);
        name.text = infoJson["name"] ?? "";
        description.text = infoJson["description"] ?? "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CarouselImage carouselImage = CarouselImage(images: images);

    SizedBox descriptionText = SizedBox(
      height: 100,
      child: TextField(
        controller: description,
        maxLines: 5,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          helperText: "",
        ),
      ),
    );

    SizedBox nameText = SizedBox(
      height: 60,
      child: TextFormField(
        controller: name,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          hintText: "Nome do Produto",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          helperText: "",
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: backAppbar("Novo Produto"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              carouselImage,
              if (isLoading)
                widgetLoading(
                  width: double.infinity,
                  height: 10,
                  horizontalPadding: 0,
                  verticalPadding: 0,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyOutlinedButton(
                      child: Text(
                        "Adicionar Imagem",
                        style: TextStyle(color: AppColors.blue),
                      ),
                      onPressed: () async {
                        Uint8List? data = await pickImage();
                        if (data != null) {
                          setState(() {
                            images.add(data);
                          });
                        }
                      },
                    ),
                  ),

                  if (images.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        identifyImage();
                      },
                      icon: Image.asset(
                        "assets/images/chatIcon.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                ],
              ),
              ...imagesPrev.map((imagePrev) {
                return Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        setText(imagePrev["classe"]);
                      },
                      child: Text(imagePrev["classe"]),
                    ),
                    Text(imagePrev["score"]),
                  ],
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Nome do Produto"), nameText],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setText(name.text);
                    },
                    icon: Image.asset(
                      "assets/images/chatIcon.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              Text("Descrição do Produto"),
              descriptionText,
              MyFilledButton(
                child: Text("Salvar", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, "/HomeSeller");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
