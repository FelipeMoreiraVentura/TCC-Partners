import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/firebase/address.dart';
import 'package:market_partners/models/address.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/popup.dart';

class AddressConfig extends StatefulWidget {
  const AddressConfig({super.key});

  @override
  State<AddressConfig> createState() => _AddressConfigState();
}

class _AddressConfigState extends State<AddressConfig> {
  String? selectedAddressId;
  List<AddressModel> addressList = [];
  User? user;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final addresses = await AddressService().getAllAddresses(currentUser.uid);
    setState(() {
      user = currentUser;
      addressList = addresses;
      if (addresses.isNotEmpty) {
        selectedAddressId = addresses.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    Popup addressPopup = Popup(
      title: "Endereços",
      child: Column(
        children:
            addressList.map((address) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedAddressId = address.id;
                    Navigator.of(context).pop();
                  });
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.street,
                            ), // pode exibir name se tiver no model
                            Text(
                              "${address.street} ${address.number}, ${address.neighborhood}, ${address.city} (${address.state})",
                              style: AppText.description,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );

    if (addressList.isEmpty) {
      return Text(
        "Nenhum endereço cadastrado",
        style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
      );
    }

    final selectedAddress = addressList.firstWhere(
      (address) => address.id == selectedAddressId,
      orElse: () => addressList.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          text: "Endereço",
          style: isMobile ? AppText.titleInfoTiny : AppText.titleInfoMedium,
        ),
        Container(
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return addressPopup;
                },
              );
            },
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.blue),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(selectedAddress.street),
                        Text(
                          "${selectedAddress.street} ${selectedAddress.number}, ${selectedAddress.neighborhood}, ${selectedAddress.city} (${selectedAddress.state})",
                          style: AppText.description,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
