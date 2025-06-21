import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String cpfOrCnpj;
  final DateTime createdAt;

  UserInformation({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.cpfOrCnpj,
    required this.createdAt,
  });

  factory UserInformation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserInformation(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      cpfOrCnpj: data['cpfOrCnpj'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'cpfOrCnpj': cpfOrCnpj,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
