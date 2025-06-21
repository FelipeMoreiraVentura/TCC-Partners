import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final String category;
  final String subcategory;
  final double price;
  final Map<String, String> specifications;
  final List<String> images;

  ProductModel({
    required this.name,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.specifications,
    required this.images,
  });

  factory ProductModel.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      name: data["name"],
      description: data["description"],
      category: data["category"],
      subcategory: data["subcategory"],
      price: data["price"],
      specifications: data["specifications"],
      images: data["images"],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "name": name,
      "description": description,
      "category": category,
      "subcategory": subcategory,
      "price": price,
      "specifications": specifications,
      "images": images,
    };
  }
}
