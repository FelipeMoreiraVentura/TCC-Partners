import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final String category;
  final String subCategory;
  final double price;
  final int stock;
  final Map<String, String> specifications;
  final List<String> images;
  final String sellerUid;
  final String? id;

  ProductModel({
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.stock,
    required this.specifications,
    required this.images,
    required this.sellerUid,
    this.id,
  });

  factory ProductModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      name: data["name"],
      description: data["description"],
      category: data["category"],
      subCategory: data["subCategory"],
      price: data["price"],
      stock: data["stock"] ?? 0,
      specifications: Map<String, String>.from(data["specifications"] ?? {}),
      images: List<String>.from(data["images"]),
      sellerUid: data["sellerUid"],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "name": name,
      "description": description,
      "category": category,
      "subCategory": subCategory,
      "price": price.toDouble(),
      "stock": stock.toDouble(),
      "specifications": specifications,
      "images": images,
      "sellerUid": sellerUid,
    };
  }
}
