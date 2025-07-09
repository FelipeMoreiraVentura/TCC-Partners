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
}
