import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> registerProduct(ProductModel product) async {
    try {
      await _db.collection("products").add(product.toFirebase());
      return "sucess";
    } catch (e) {
      return "Erro ao salvar o produto: $e";
    }
  }

  Future<List<ProductModel>> getProductsBySelley(String sellerUid) async {
    try {
      final doc =
          await _db
              .collection("products")
              .where("sellerUid", isEqualTo: sellerUid)
              .get();
      return doc.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      print("Erro ao buscar produtos: $e");
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
      print("Erro ao pegar produtos aleatorios: $e");
      rethrow;
    }
  }

  Future<ProductModel> getProduct(String productId) async {
    try {
      final doc = await _db.collection("products").doc(productId).get();
      return ProductModel.fromFirebase(doc);
    } catch (e) {
      print("Erro ao buscar produto: $e");
      rethrow;
    }
  }
}
