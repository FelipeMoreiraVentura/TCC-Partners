import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:market_partners/firebase/product.dart';
import 'package:market_partners/firebase/user.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/screens/seller/new_or_edit_product/widget/carousel_image.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/pick_image.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/toast.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/back_appbar.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/loading.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/my_outlined_button.dart';

import '../../../device/api.dart';

class NewOrEditProduct extends StatefulWidget {
  final String? productId;

  const NewOrEditProduct({super.key, this.productId});

  @override
  State<NewOrEditProduct> createState() => _NewOrEditProductState();
}

class _NewOrEditProductState extends State<NewOrEditProduct> {
  bool isLoading = false;
  bool isFetching = false;

  List<Map<String, dynamic>> imagesPrev = [];
  List<Uint8List> images = [];
  Map<String, String> specifications = {};

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController specification = TextEditingController();
  TextEditingController specificationValue = TextEditingController();

  bool get isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      fetchProduct(widget.productId!);
    }
  }

  Future<void> fetchProduct(String id) async {
    setState(() => isFetching = true);

    try {
      ProductModel product = await ProductService().getProduct(id);
      setState(() {
        name.text = product.name;
        description.text = product.description;
        price.text = product.price.toStringAsFixed(2);
        stock.text = product.stock.toString();
        specifications = Map.from(product.specifications);
        images = product.images.map((b64) => base64Decode(b64)).toList();
      });
    } catch (_) {
      ToastService.error("Erro ao carregar produto.");
    }

    setState(() => isFetching = false);
  }

  Future<void> identifyImage() async {
    if (images.isNotEmpty && !isEditing) {
      setState(() => isLoading = true);
      final imagemBase64 = base64Encode(images[0]);

      Response data = await Api.post("/identify_image", {
        "image": imagemBase64,
      });

      if (data.statusCode == 200) {
        final parsedList = jsonDecode(utf8.decode(data.bodyBytes));
        setState(() {
          imagesPrev = parsedList.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      }
    }
  }

  Future<void> setText(String product) async {
    if (product == "" || isEditing) return;

    setState(() => isLoading = true);
    Response data = await Api.post("/set_product", {"product": product});

    if (data.statusCode == 200) {
      final infoJson = jsonDecode(data.body);
      setState(() {
        name.text = infoJson["name"] ?? "";
        description.text = infoJson["description"] ?? "";
        specifications = Map<String, String>.from(
          infoJson["specifications"] ?? {},
        );
        isLoading = false;
      });
    }
  }

  Future<void> postProduct() async {
    if (name.text.isEmpty || price.text.isEmpty || images.isEmpty) {
      ToastService.error("Preencha todos os campos obrigatórios!");
      return;
    }

    final product = ProductModel(
      id: widget.productId,
      name: name.text,
      description: description.text,
      category: "none",
      subCategory: "none",
      price: double.tryParse(price.text.replaceAll(',', '.')) ?? 0.0,
      stock: int.tryParse(stock.text) ?? 0,
      specifications: specifications,
      images: images.map((img) => base64Encode(img)).toList(),
      sellerUid: UserService().getUid() ?? '',
    );

    if (isEditing) {
      await ProductService().updateProduct(product);
    } else {
      await ProductService().registerProduct(product);
      setState(() {
        name.clear();
        description.clear();
        price.clear();
        stock.clear();
        specification.clear();
        specificationValue.clear();
        images = [];
        specifications = {};
        imagesPrev = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    if (isFetching) {
      return Scaffold(
        appBar: backAppbar("Carregando..."),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Column> imagesView =
        images.map((image) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      appBar: backAppbar(isEditing ? "Editar Produto" : "Novo Produto"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 50,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: TranslatedText(
                        text: "Adicionar Imagem",
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
                  if (images.isNotEmpty && !isEditing)
                    IconButton(
                      onPressed: identifyImage,
                      icon: Image.asset(
                        "assets/images/chatIcon.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                ],
              ),
              if (!isEditing)
                ...imagesPrev.map((imagePrev) {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: () => setText(imagePrev["classe"]),
                        child: Text(imagePrev["classe"]),
                      ),
                      Text(imagePrev["score"]),
                    ],
                  );
                }),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
                    TranslatedText(
                      text: "Informações do Produto",
                      style: AppText.titleInfoTiny,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: InputType.text,
                            label: "Nome do Produto",
                            controller: name,
                            validation: false,
                          ),
                        ),
                        if (!isEditing)
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
                      type: InputType.text,
                      label: "Descrição do Produto",
                      multiline: true,
                      controller: description,
                      validation: false,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: InputType.doubleType,
                            label: "Preço",
                            controller: price,
                            validation: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Input(
                            type: InputType.intType,
                            label: "Quantidade",
                            controller: stock,
                            validation: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TranslatedText(
                      text: "Especificações",
                      style: AppText.titleInfoTiny,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            type: InputType.text,
                            label: "Especificação",
                            controller: specification,
                            validation: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Input(
                            type: InputType.text,
                            label: "Categoria",
                            controller: specificationValue,
                            validation: false,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (specification.text.isNotEmpty &&
                                specificationValue.text.isNotEmpty) {
                              setState(() {
                                specifications[specification.text] =
                                    specificationValue.text;
                                specification.clear();
                                specificationValue.clear();
                              });
                            }
                          },
                          icon: Icon(Icons.add, color: AppColors.blue),
                        ),
                      ],
                    ),
                    ...specificationsView,
                    MyFilledButton(
                      onPressed: postProduct,
                      child: TranslatedText(
                        text: isEditing ? "Atualizar" : "Salvar",
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
