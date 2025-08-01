import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/utils/toast.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerProduct(ProductModel product) async {
    try {
      await _db.collection("products").add(product.toFirebase());
      ToastService.success("Produto salvo com sucesso!");
    } catch (e) {
      ToastService.error("Erro ao salvar o produto: $e");
    }
  }

  Future<List<ProductModel>> getProductsBySeller(String sellerUid) async {
    try {
      final doc =
          await _db
              .collection("products")
              .where("sellerUid", isEqualTo: sellerUid)
              .get();
      return doc.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      ToastService.error("Erro ao buscar produtos: $e");
      rethrow;
    }
  }

  Future<List<ProductModel>> getRandomProducts(int quantidade) async {
    try {
      final doc = await _db.collection('products').get();
      final all =
          doc.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
      all.shuffle();

      return all.take(quantidade).toList();
    } catch (e) {
      ToastService.error("Erro ao pegar produtos aleatorios: $e");
      rethrow;
    }
  }

  Future<ProductModel> getProduct(String productId) async {
    try {
      final doc = await _db.collection("products").doc(productId).get();
      return ProductModel.fromFirebase(doc);
    } catch (e) {
      ToastService.error("Erro ao buscar produto: $e");
      rethrow;
    }
  }

  Future<List<ProductModel>> getProducts(List<String> productsId) async {
    try {
      final docs = await Future.wait(
        productsId.map((id) => _db.collection("products").doc(id).get()),
      );
      return docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      ToastService.error("Erro ao buscar produto: $e");
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProductsByName(String name) async {
    try {
      final doc =
          await _db
              .collection("products")
              .where("name", isGreaterThanOrEqualTo: name)
              .where("name", isLessThanOrEqualTo: '$name\uf8ff')
              .get();

      return doc.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      ToastService.error("Erro ao buscar produtos por nome: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection("products").doc(productId).delete();
    } catch (e) {
      ToastService.error("Erro ao deletar produto: $e");
      rethrow;
    }
  }
}
