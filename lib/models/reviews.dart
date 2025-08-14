import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsModels {
  final String buyerId;
  final String sellerId;
  final String buyerComment;
  final String sellerComment;
  final int rating;
  final String productId;
  final String? purchaseId;
  final String? id;

  ReviewsModels({
    required this.buyerId,
    required this.sellerId,
    required this.buyerComment,
    required this.sellerComment,
    required this.rating,
    required this.productId,
    this.purchaseId,
    this.id,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'buyerComment': buyerComment,
      'sellerComment': sellerComment,
      'rating': rating,
      'productId': productId,
      'purchaseId': purchaseId,
    };
  }

  factory ReviewsModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewsModels(
      buyerId: data['buyerId'],
      sellerId: data['sellerId'],
      buyerComment: data['buyerComment'],
      sellerComment: data['sellerComment'],
      rating: data['rating'],
      productId: data['productId'],
      purchaseId: data['purchaseId'],
      id: doc.id,
    );
  }
}
