import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/popup.dart';

class PopupAdressInfo extends StatefulWidget {
  const PopupAdressInfo({super.key});

  @override
  State<PopupAdressInfo> createState() => _PopupAdressInfoState();
}

class _PopupAdressInfoState extends State<PopupAdressInfo> {
  @override
  Widget build(BuildContext context) {
    List<Map> adressList = [
      {
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

    List<Widget> adressView =
        adressList.map((adress) {
          return SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_location_alt_outlined,
                    color: AppColors.blue,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(adress["name"]),
                    Text(
                      "${adress["street"]} ${adress["number"]} - ${adress["city"]}(${adress["state"]})",
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList();

    return Popup(title: "Endereço", child: Column(children: adressView));
  }
}
