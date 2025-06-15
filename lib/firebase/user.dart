import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> registerUser(
    String email,
    String password,
    String name,
    String cpfOrCnpj,
    String phone,
    String role,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'cpfOrCnpj': cpfOrCnpj,
          'phone': phone,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return 'success';
      } else {
        return 'Erro: Usuário nulo';
      }
    } catch (e) {
      return 'Erro: $e';
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return 'Erro: $e';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
