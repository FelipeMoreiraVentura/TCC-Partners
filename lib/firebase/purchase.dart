import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/purchase.dart';
import 'package:market_partners/utils/toast.dart';

class PurchaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createPurchase({required PurchaseModel purchase}) async {
    try {
      await _db.collection('purchases').add(purchase.toFirestore());
      ToastService.success('Compra realizada com sucesso');
    } catch (e) {
      ToastService.error('Erro ao realizar compra: $e');
    }
  }

  Future<List<PurchaseModel>> getPurchasesByUser(
    String userId,
    String role,
  ) async {
    try {
      final querySnapshot =
          await _db
              .collection('purchases')
              .where(
                role == 'buyer' ? 'buyerId' : 'sellerId',
                isEqualTo: userId,
              )
              .get();

      return querySnapshot.docs
          .map((doc) => PurchaseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      ToastService.error('Erro ao buscar compras: $e');
      rethrow;
    }
  }
}
