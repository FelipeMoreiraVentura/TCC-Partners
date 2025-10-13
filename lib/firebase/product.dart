import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/product.dart';
import 'package:market_partners/models/purchase.dart';
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

  Future<void> updateProduct(ProductModel product) async {
    if (product.id == null) {
      ToastService.error("ID do produto não encontrado para edição.");
      return;
    }

    try {
      await _db
          .collection("products")
          .doc(product.id)
          .update(product.toFirebase());
      ToastService.success("Produto atualizado com sucesso!");
    } catch (e) {
      ToastService.error("Erro ao atualizar produto: $e");
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

  Future<List<ProductModel>> getRandomProducts(quantidade) async {
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

  Future<List<ProductModel>> getTopPurchasedProducts() async {
    try {
      final purchasesSnapshot = await _db.collection('purchases').get();

      final Map<String, int> productCount = {};

      for (var doc in purchasesSnapshot.docs) {
        final purchase = PurchaseModel.fromFirestore(doc);
        productCount[purchase.productId] =
            (productCount[purchase.productId] ?? 0) + 1;
      }

      final topProductIds =
          productCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      final List<String> topIds =
          topProductIds.take(12).map((entry) => entry.key).toList();

      final List<ProductModel> topProducts = [];

      for (String productId in topIds) {
        final productDoc =
            await _db.collection('products').doc(productId).get();
        if (productDoc.exists) {
          topProducts.add(ProductModel.fromFirebase(productDoc));
        }
      }

      if (topProducts.length < 12) {
        final allProductsSnapshot = await _db.collection('products').get();
        final allProducts =
            allProductsSnapshot.docs
                .map((doc) => ProductModel.fromFirebase(doc))
                .where((p) => !topIds.contains(p.id))
                .toList();

        allProducts.shuffle();

        final needed = 12 - topProducts.length;
        topProducts.addAll(allProducts.take(needed));
      }

      return topProducts;
    } catch (e) {
      ToastService.error("Erro ao buscar produtos mais comprados: $e");
      rethrow;
    }
  }

  Future<List<ProductModel>> getRecommendedProductsForUser(
    String userId,
  ) async {
    try {
      // 1. Busca todas as compras feitas pelo usuário
      final purchasesSnapshot =
          await _db
              .collection('purchases')
              .where('buyerId', isEqualTo: userId)
              .get();

      // 2. Verifica se o usuário ainda não fez nenhuma compra
      if (purchasesSnapshot.docs.isEmpty) {
        // Retorna 12 produtos aleatórios
        final allProductsSnapshot = await _db.collection('products').get();
        final allProducts =
            allProductsSnapshot.docs
                .map((doc) => ProductModel.fromFirebase(doc))
                .toList();

        allProducts.shuffle();
        return allProducts.take(12).toList();
      }

      // 3. Extrai os IDs dos produtos comprados
      final boughtProductIds =
          purchasesSnapshot.docs
              .map((doc) => PurchaseModel.fromFirestore(doc).productId)
              .toSet();

      // 4. Busca os produtos comprados para obter as categorias
      final Set<String> categories = {};
      for (String productId in boughtProductIds) {
        final productDoc =
            await _db.collection('products').doc(productId).get();
        if (productDoc.exists) {
          final product = ProductModel.fromFirebase(productDoc);
          categories.add(product.category);
        }
      }

      // 5. Busca todos os produtos das categorias compradas
      final categoryProductsSnapshot =
          await _db
              .collection('products')
              .where('category', whereIn: categories.toList())
              .get();

      // 6. Filtra os produtos que o usuário ainda não comprou
      final filteredProducts =
          categoryProductsSnapshot.docs
              .map((doc) => ProductModel.fromFirebase(doc))
              .where((product) => !boughtProductIds.contains(product.id))
              .toList();

      // 7. Embaralha e retorna até 12 produtos
      filteredProducts.shuffle();
      return filteredProducts.take(12).toList();
    } catch (e) {
      ToastService.error("Erro ao buscar recomendações: $e");
      rethrow;
    }
  }

  Future<List<ProductModel>> getRandomProductsByCategory(
    String category,
  ) async {
    try {
      final querySnapshot =
          await _db
              .collection('products')
              .where('category', isEqualTo: category)
              .get();

      final products =
          querySnapshot.docs
              .map((doc) => ProductModel.fromFirebase(doc))
              .toList();

      products.shuffle();

      return products.take(16).toList();
    } catch (e) {
      ToastService.error("Erro ao pegar produtos da categoria '$category': $e");
      rethrow;
    }
  }

  Future<List<String>> getProductNameSuggestions(String query) async {
    try {
      final normalized = query.trim().toLowerCase();

      if (normalized.isEmpty) return [];

      final result =
          await _db
              .collection("products")
              .orderBy("name")
              .startAt([query])
              .endAt(["$query\uf8ff"])
              .limit(20)
              .get();

      final filtered =
          result.docs
              .map((doc) => doc['name'] as String)
              .where((name) => name.toLowerCase().startsWith(normalized))
              .toSet()
              .take(10)
              .toList();

      return filtered;
    } catch (e) {
      ToastService.error("Erro ao buscar sugestões: $e");
      return [];
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
      if (name.toLowerCase() == "all") {
        final snap = await _db.collection("products").get();
        return snap.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
      }
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
