import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';

import '../../../../device/api.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({super.key});

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  Uint8List? imageFile;
  List<Map<String, dynamic>> imagesPrev = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    identfyImage() async {
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });

        final imagemBase64 = base64Encode(imageFile!);
        Response data = await Api.post("identify_image", {
          "image": imagemBase64,
        });
        if (data.statusCode == 200) {
          setState(() {
            final List<dynamic> parsedList = jsonDecode(data.body);
            imagesPrev = parsedList.cast<Map<String, dynamic>>();

            isLoading = false;
          });
        }
      }
    }

    InkWell imageButton = InkWell(
      onTap: () async {
        Uint8List? data = await pickImage();
        setState(() {
          imageFile = data;
        });
      },
      child:
          imageFile == null
              ? Icon(Icons.add, size: 300)
              : Image.memory(imageFile!, width: 300, height: 300),
    );

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        imageButton,
        if (imageFile != null)
          Row(
            children: [
              Image.asset("assets/images/chatIcon.png", width: 40, height: 40),
              MyOutlinedButton(
                onPressed: () async {
                  await identfyImage();
                },
                width: 150,
                child: Text("Gerar previsão"),
              ),
              if (isLoading)
                widgetLoading(
                  verticalPadding: 20,
                  horizontalPadding: 5,
                  height: 10,
                  width: 40,
                ),
            ],
          ),
        ...imagesPrev.map((imagePrev) {
          return Row(
            children: [
              TextButton(onPressed: () {}, child: Text(imagePrev["classe"])),
              Text(imagePrev["score"]),
            ],
          );
        }),
      ],
    );
  }
}
