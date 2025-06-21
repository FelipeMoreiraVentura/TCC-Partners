import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_partners/models/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String password,
    required String name,
    required String cpfOrCnpj,
    required String phone,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        final userInfo = UserInformation(
          uid: user.uid,
          name: name,
          email: email,
          cpfOrCnpj: cpfOrCnpj,
          phone: phone,
          role: role,
          createdAt: DateTime.now(),
        );

        await _db.collection('users').doc(user.uid).set(userInfo.toFirestore());

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

  Future<String> getRole(String userId) async {
    final doc = await _db.collection("users").doc(userId).get();
    UserInformation information = UserInformation.fromFirestore(doc);

    return information.role;
  }

  Future<UserInformation> getInfo(String userId) async {
    final doc = await _db.collection("users").doc(userId).get();
    return UserInformation.fromFirestore(doc);
  }
}
