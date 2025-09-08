import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/screens/seller/new_product/widget/carousel_image.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/input.dart';
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
  Map<String, String> specifications = {};

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController specification = TextEditingController();
  TextEditingController specificationValue = TextEditingController();

  identifyImage() async {
    if (images.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      final imagemBase64 = base64Encode(images[0]);
      Response data = await Api.post("/identify_image", {
        "image": imagemBase64,
      });
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

  setText(String product) async {
    if (product == "") return "";
    setState(() {
      isLoading = true;
    });
    Response data = await Api.post("/set_product", {"product": product});
    if (data.statusCode == 200) {
      setState(() {
        Map<String, dynamic> infoJson = jsonDecode(data.body);
        name.text = infoJson["name"] ?? "";
        description.text = infoJson["description"] ?? "";
        specifications = infoJson["specifications"] ?? "";
        isLoading = false;
      });
    }
  }

  Future<void> postProduct() async {
    if (name.text.isEmpty || price.text.isEmpty || images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos obrigatórios!")),
      );
      return;
    }

    final produto = ProductModel(
      name: name.text,
      description: description.text,
      category: "none",
      subCategory: "none",
      price: double.tryParse(price.text.replaceAll(',', '.')) ?? 0.0,
      stock: int.tryParse(stock.text) ?? 0,
      specifications: specifications,
      images:
          images.map((image) {
            return base64Encode(image);
          }).toList(),
      sellerUid: UserService().getUid() ?? '',
    );

    await ProductService().registerProduct(produto);
    setState(() {
      name.text = "";
      description.text = "";
      price.text = "";
      stock.text = "";
      specification.text = "";
      specificationValue.text = "";
      images = [];
      specifications = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    List<Column> imagesView =
        images.map((image) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.cancel, color: AppColors.blue),
                onPressed: () {
                  setState(() {
                    images.remove(image);
                  });
                },
              ),
              Image.memory(image, width: 150, height: 150),
            ],
          );
        }).toList();

    List<Column> specificationsView =
        specifications.entries.map((s) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel, color: AppColors.blue),
                    onPressed: () {
                      setState(() {
                        specifications.remove(s.key);
                      });
                    },
                  ),
                  Text('${s.key}:', style: TextStyle(fontFamily: "bold")),
                  Text(s.value),
                ],
              ),
            ],
          );
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: backAppbar("Novo Produto"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 50,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselImage(images: imagesView),
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
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColors.menu,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0.2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informações do Produto",
                      style: AppText.titleInfoTiny,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: "Nome do Produto",
                            controller: name,
                            validation: false,
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
                    SizedBox(height: 10),
                    Input(
                      type: "Descrição do Produto",
                      controller: description,
                      validation: false,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: "Preço",
                            controller: price,
                            validation: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Input(
                            type: "Quantidade",
                            controller: stock,
                            validation: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("Especificações", style: AppText.titleInfoTiny),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: "Especificação",
                            controller: specification,
                            validation: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Input(
                            type: "Categoria",
                            controller: specificationValue,
                            validation: false,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (specification.text.isNotEmpty &&
                                  specificationValue.text.isNotEmpty) {
                                specifications[specification.text] =
                                    specificationValue.text;
                                specification.clear();
                                specificationValue.clear();
                              }
                            });
                          },
                          icon: Icon(Icons.add, color: AppColors.blue),
                        ),
                      ],
                    ),
                    ...specificationsView,
                    MyFilledButton(
                      onPressed: () {
                        postProduct();
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
