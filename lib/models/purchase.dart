import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  final String productId;
  final String buyerId;
  final String sellerId;
  final String? id;
  final DateTime? createdAt;
  final double price;

  PurchaseModel({
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    this.id,
    this.createdAt,
    required this.price,
  });
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'price': price,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory PurchaseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PurchaseModel(
      productId: data['productId'],
      buyerId: data['buyerId'],
      sellerId: data['sellerId'],
      id: doc.id,
      createdAt: data['createdAt']?.toDate(),
      price: data['price'].toDouble(),
    );
  }
}
