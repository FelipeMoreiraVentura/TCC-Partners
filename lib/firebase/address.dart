import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/address.dart';
import 'package:market_partners/utils/toast.dart';

class AddressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveAddress(AddressModel address) async {
    try {
      await _db
          .collection('addresses')
          .doc(address.uid)
          .set(address.toFirestore());
      ToastService.success('Endereço salvo com sucesso');
    } catch (e) {
      ToastService.error('Erro ao salvar endereço: $e');
    }
  }

  Future<AddressModel?> getAddress(String uid) async {
    try {
      final doc = await _db.collection('addresses').doc(uid).get();

      if (doc.exists) {
        return AddressModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      ToastService.error('Erro ao buscar endereço: $e');
      return null;
    }
  }

  Future<void> deleteAddress(String uid) async {
    try {
      await _db.collection('addresses').doc(uid).delete();
      ToastService.success('Endereço removido com sucesso');
    } catch (e) {
      ToastService.error('Erro ao remover endereço: $e');
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
}
