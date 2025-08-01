import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/utils/toast.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addItemToCart({
    required String userId,
    required String productId,
  }) async {
    try {
      final cartRef = _db.collection('carts').doc(userId);

      final doc = await cartRef.get();

      if (doc.exists) {
        List<dynamic> currentProducts = doc['products'] ?? [];

        if (!currentProducts.contains(productId)) {
          await cartRef.update({
            'products': FieldValue.arrayUnion([productId]),
          });
        }
      } else {
        await cartRef.set({
          'products': [productId],
        });
      }

      ToastService.success('Produto adicionado ao carrinho');
    } catch (e) {
      ToastService.error('Erro ao adicionar produto ao carrinho: $e');
    }
  }

  Future<List<String>> getCartItems(String userId) async {
    final doc = await _db.collection('carts').doc(userId).get();

    if (doc.exists) {
      List<dynamic> productIds = doc['products'] ?? [];
      return List<String>.from(productIds);
    } else {
      return [];
    }
  }
}
