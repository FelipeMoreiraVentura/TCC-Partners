import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String uid;
  final String street;
  final int number;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressModel({
    required this.uid,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      uid: data["uid"],
      street: data['street'],
      number: data["number"],
      neighborhood: data['neighborhood'],
      city: data['city'],
      state: data['state'],
      postalCode: data['postalCode'],
      country: data['country'],
    );
  }
}
