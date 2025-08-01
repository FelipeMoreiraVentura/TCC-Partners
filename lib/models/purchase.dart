import 'package:cloud_firestore/cloud_firestore.dart';

class Avality {
  final String buyerComment;
  final int rating;
  final String sellerComment;

  Avality({
    required this.buyerComment,
    required this.rating,
    required this.sellerComment,
  });

  Map<String, dynamic> toMap() {
    return {
      'buyerComment': buyerComment,
      'rating': rating,
      'sellerComment': sellerComment,
    };
  }
}

class PurchaseModel {
  final String productId;
  final String buyerId;
  final String sellerId;
  final String? id;
  final DateTime? createdAt;
  final double price;
  final Avality? avality;

  PurchaseModel({
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    this.id,
    this.createdAt,
    required this.price,
    required this.avality,
  });
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'price': price,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'avality': null,
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
      price: data['price'],
      avality:
          data['avality'] != null
              ? Avality(
                buyerComment: data['avality']['buyerComment'],
                rating: data['avality']['rating'],
                sellerComment: data['avality']['sellerComment'],
              )
              : null,
    );
  }
}
