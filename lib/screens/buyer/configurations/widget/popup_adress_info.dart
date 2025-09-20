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
  String selectedAddressId = "";
  User? user;
  bool editAddress = false;

  // Controllers
  final TextEditingController name = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController neighborhood = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController complement = TextEditingController();
  final TextEditingController phone = TextEditingController();

  List<AddressModel> addressList = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    User? userData = FirebaseAuth.instance.currentUser;
    if (userData == null) return;

    final addresses = await AddressService().getAllAddresses(userData.uid);
    setState(() {
      user = userData;
      addressList = addresses;
    });
  }

  void _fillForm(AddressModel address) {
    selectedAddressId = address.id;
    editAddress = true;

    street.text = address.street;
    number.text = address.number.toString();
    neighborhood.text = address.neighborhood;
    city.text = address.city;
    state.text = address.state;
    zipCode.text = address.postalCode;
    complement.text = "";
    phone.text = "";
  }

  void _clearForm() {
    selectedAddressId = "";
    editAddress = true;

    street.clear();
    number.clear();
    neighborhood.clear();
    city.clear();
    state.clear();
    zipCode.clear();
    complement.clear();
    phone.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> addressView =
        addressList.map((address) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _fillForm(address);
                    });
                  },
                  icon: const Icon(
                    Icons.edit_location_alt_outlined,
                    color: AppColors.blue,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Endereço", style: AppText.md),
                      Text(
                        "${address.street} ${address.number}, "
                        "${address.neighborhood}, ${address.city} (${address.state})",
                        style: AppText.description,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await AddressService().deleteAddress(address.id);
                    await _loadAddresses();
                  },
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
              ],
            ),
          );
        }).toList();

    List<Widget> widgetEditAddress = [
      IconButton(
        onPressed: () {
          setState(() {
            selectedAddressId = "";
            editAddress = false;
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
      Input(
        type: InputType.text,
        label: "Rua",
        controller: street,
        validation: false,
      ),
      Input(
        type: InputType.intType,
        label: "Número",
        controller: number,
        validation: false,
      ),
      Input(
        type: InputType.text,
        label: "Bairro",
        controller: neighborhood,
        validation: false,
      ),
      Input(
        type: InputType.text,
        label: "Cidade",
        controller: city,
        validation: false,
      ),
      Input(
        type: InputType.text,
        label: "Estado",
        controller: state,
        validation: false,
      ),
      Input(
        type: InputType.cep,
        label: "CEP",
        controller: zipCode,
        validation: false,
      ),
      Input(
        type: InputType.text,
        label: "Complemento",
        controller: complement,
        validation: false,
      ),
      Input(
        type: InputType.telefone,
        label: "Telefone",
        controller: phone,
        validation: false,
      ),
    ];

    return Popup(
      title: "Endereço",
      actionButtons: editAddress,
      confirmAction: () async {
        final newAddress = AddressModel(
          id: selectedAddressId, // vazio = novo, preenchido = update
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
          editAddress = false;
          selectedAddressId = "";
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            editAddress
                ? widgetEditAddress
                : [
                  ...addressView,
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _clearForm();
                      });
                    },
                    icon: const Icon(
                      Icons.add_location_alt_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                ],
      ),
    );
  }
}
