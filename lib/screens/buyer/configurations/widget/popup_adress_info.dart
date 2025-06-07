import 'package:flutter/material.dart';
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
  bool editAdress = false;

  TextEditingController name = TextEditingController(text: "");
  TextEditingController street = TextEditingController(text: "");
  TextEditingController number = TextEditingController(text: "");
  TextEditingController neighborhood = TextEditingController(text: "");
  TextEditingController city = TextEditingController(text: "");
  TextEditingController state = TextEditingController(text: "");
  TextEditingController zipCode = TextEditingController(text: "");
  TextEditingController complement = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");

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
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectAdress = adress["zipCode"];
                      editAdress = true;
                      name.text = adress["name"];
                      street.text = adress["street"];
                      number.text = adress["number"];
                      neighborhood.text = adress["neighborhood"];
                      city.text = adress["city"];
                      state.text = adress["state"];
                      zipCode.text = adress["zipCode"];
                      complement.text = adress["complement"];
                      phone.text = adress["phone"];
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
                      Text(adress["name"]),
                      Text(
                        "${adress["street"]} ${adress["number"]}, ${adress["neighborhood"]}, ${adress["city"]}(${adress["state"]})",
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
        icon: Icon(Icons.arrow_back),
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
      confirmAction: () {
        print("FireBase");
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
