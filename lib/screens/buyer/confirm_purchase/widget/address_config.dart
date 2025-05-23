import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/popup.dart';

class AddressConfig extends StatefulWidget {
  final String selectesAddress;

  const AddressConfig({super.key, required this.selectesAddress});

  @override
  State<AddressConfig> createState() => _AddressConfigState();
}

class _AddressConfigState extends State<AddressConfig> {
  String selectesAddress = "124";

  List<Map> addressList = [
    {
      "id": "124",
      'name': 'João da Silva',
      'street': 'Rua das Acácias',
      'number': '123',
      'neighborhood': 'Jardim das Flores',
      'city': 'São Paulo',
      'state': 'SP',
      'zipCode': '01234-567',
      'complement': 'Apartamento 12B',
      'phone': '(11) 91234-5678',
    },
    {
      "id": "wew2e",
      'name': 'Maria Oliveira',
      'street': 'Avenida Brasil',
      'number': '456',
      'neighborhood': 'Centro',
      'city': 'Rio de Janeiro',
      'state': 'RJ',
      'zipCode': '12345-678',
      'complement': 'Casa',
      'phone': '(21) 99876-5432',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Popup addressPoppup = Popup(
      title: "Endereços",
      child: Column(
        children:
            addressList.map((address) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectesAddress = address["id"];
                    Navigator.of(context).pop();
                  });
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.blue),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address["name"]),
                          Text(
                            "${address["street"]} ${address["number"]}, ${address["neighborhood"]}, ${address["city"]}(${address["state"]})",
                            style: AppText.description,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );

    final filterAddress = addressList.firstWhere(
      (address) => address["id"] == selectesAddress,
    );

    return Container(
      height: 100,
      width: 450,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return addressPoppup;
            },
          );
        },
        child: Center(
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.blue),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(filterAddress["name"] ?? ""),
                  Text(
                    "${filterAddress["street"]} ${filterAddress["number"]}, ${filterAddress["neighborhood"]}, ${filterAddress["city"]}(${filterAddress["state"]})",
                    style: AppText.description,
                    softWrap: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
