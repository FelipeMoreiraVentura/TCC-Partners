import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;

  CartItem({required this.productId});
  Map<String, dynamic> toFirestore() {
    return {'productId': productId};
  }

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(productId: data['productId']);
  }
}
