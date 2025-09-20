import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/utils/toast.dart';

class ReviewsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReview(ReviewsModels review) async {
    try {
      await _db.collection('reviews').add(review.toFirestore());
      ToastService.success("Avaliação adicionada com sucesso!");
    } catch (e) {
      ToastService.error("Erro ao adicionar avaliação: $e");
    }
  }

  Future<void> updateReview(ReviewsModels review) async {
    try {
      final query =
          await _db
              .collection('reviews')
              .where('purchaseId', isEqualTo: review.purchaseId)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        ToastService.error("Avaliação não encontrada para atualização.");
        return;
      }

      final docId = query.docs.first.id;

      await _db.collection('reviews').doc(docId).update({
        'sellerComment': review.sellerComment,
      });

      ToastService.success("Resposta do vendedor enviada com sucesso!");
    } catch (e) {
      ToastService.error("Erro ao responder avaliação: $e");
    }
  }

  Future<List<ReviewsModels>> getReviews(String id, String where) async {
    final querySnapshot =
        await _db.collection('reviews').where(where, isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => ReviewsModels.fromFirestore(doc))
          .toList();
    } else {
      return [];
    }
  }

  Future<ReviewsModels?> getReviewByPurchaseId(String purchaseId) async {
    try {
      final querySnapshot =
          await _db
              .collection('reviews')
              .where('purchaseId', isEqualTo: purchaseId)
              .get();
      return querySnapshot.docs.isNotEmpty
          ? ReviewsModels.fromFirestore(querySnapshot.docs.first)
          : null;
    } catch (e) {
      ToastService.error("Erro ao buscar avaliação: $e");
      rethrow;
    }
  }
}
