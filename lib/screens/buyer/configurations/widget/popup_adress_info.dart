import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/address.dart';
import 'package:market_partners/models/address.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupAdressInfo extends StatefulWidget {
  const PopupAdressInfo({super.key});

  @override
  State<PopupAdressInfo> createState() => _PopupAdressInfoState();
}

class _PopupAdressInfoState extends State<PopupAdressInfo> {
  late String selectAdress = "";
  User? user;
  bool editAdress = false;

  // controllers
  TextEditingController name = TextEditingController(text: "");
  TextEditingController street = TextEditingController(text: "");
  TextEditingController number = TextEditingController(text: "");
  TextEditingController neighborhood = TextEditingController(text: "");
  TextEditingController city = TextEditingController(text: "");
  TextEditingController state = TextEditingController(text: "");
  TextEditingController zipCode = TextEditingController(text: "");
  TextEditingController complement = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");

  List<AddressModel> adressList = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    User? userData = FirebaseAuth.instance.currentUser;
    final addresses = await AddressService().getAllAddresses(userData!.uid);
    setState(() {
      user = userData;
      adressList = addresses;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> adressView =
        adressList.map((adress) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectAdress = adress.uid;
                      editAdress = true;
                      name.text = adress.uid;
                      street.text = adress.street;
                      number.text = adress.number.toString();
                      neighborhood.text = adress.neighborhood;
                      city.text = adress.city;
                      state.text = adress.state;
                      zipCode.text = adress.postalCode;
                      complement.text = ""; // se quiser usar depois
                      phone.text = ""; // se quiser usar depois
                    });
                  },
                  icon: Icon(
                    Icons.edit_location_alt_outlined,
                    color: AppColors.blue,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adress.uid,
                      ), // aqui pode trocar por name se tiver no model
                      Text(
                        "${adress.street} ${adress.number}, ${adress.neighborhood}, ${adress.city} (${adress.state})",
                        style: AppText.description,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList();

    List<Widget> widgetEditAdress = [
      IconButton(
        onPressed: () {
          setState(() {
            selectAdress = "";
            editAdress = false;
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
      Input(type: "Nome", controller: name, validation: false),
      Input(type: "Rua", controller: street, validation: false),
      Input(type: "Numero", controller: number, validation: false),
      Input(type: "Bairro", controller: neighborhood, validation: false),
      Input(type: "Cidade", controller: city, validation: false),
      Input(type: "Estado", controller: state, validation: false),
      Input(type: "CEP", controller: zipCode, validation: false),
      Input(type: "Complemento", controller: complement, validation: false),
      Input(type: "Telefone", controller: phone, validation: false),
    ];

    return Popup(
      title: "Endereço",
      actionButtons: editAdress,
      confirmAction: () async {
        final newAddress = AddressModel(
          uid: user!.uid,
          street: street.text,
          number: int.tryParse(number.text) ?? 0,
          neighborhood: neighborhood.text,
          city: city.text,
          state: state.text,
          postalCode: zipCode.text,
          country: "Brasil",
        );

        await AddressService().saveAddress(newAddress);
        await _loadAddresses();

        setState(() {
          editAdress = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            editAdress
                ? widgetEditAdress
                : [
                  ...adressView,
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectAdress = "";
                        editAdress = true;
                        name.text = "";
                        street.text = "";
                        number.text = "";
                        neighborhood.text = "";
                        city.text = "";
                        state.text = "";
                        zipCode.text = "";
                        complement.text = "";
                        phone.text = "";
                      });
                    },
                    icon: Icon(
                      Icons.add_location_alt_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                ],
      ),
    );
  }
}
