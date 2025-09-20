import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/address.dart';
import 'package:market_partners/utils/toast.dart';

class AddressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveAddress(AddressModel address) async {
    try {
      if (address.id.isEmpty) {
        await _db.collection('addresses').add(address.toFirestore());
      } else {
        // Atualizar existente
        await _db
            .collection('addresses')
            .doc(address.id)
            .update(address.toFirestore());
      }
      ToastService.success('Endereço salvo com sucesso');
    } catch (e) {
      ToastService.error('Erro ao salvar endereço: $e');
    }
  }

  Future<List<AddressModel>> getAllAddresses(String uid) async {
    try {
      final snapshot =
          await _db.collection('addresses').where('uid', isEqualTo: uid).get();

      return snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      ToastService.error('Erro ao buscar endereços: $e');
      return [];
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _db.collection('addresses').doc(id).delete();
      ToastService.success('Endereço removido com sucesso');
    } catch (e) {
      ToastService.error('Erro ao remover endereço: $e');
    }
  }
}
