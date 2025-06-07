import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/card_product.dart';

class HistoryCard extends StatelessWidget {
  final Map<String, dynamic> history;

  const HistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    final date = DateTime.parse(history["date"]);

    Column historyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year} - "
          "${date.hour.toString().padLeft(2, '0')}:"
          "${date.minute.toString().padLeft(2, '0')}",
          style: AppText.titleInfoTiny,
        ),
        SizedBox(height: 4),
        Text("Id da Compra: ${history["id"]}"),
        SizedBox(height: 8),
        Text("Valor Total: R\$ ${history["total"].toStringAsFixed(2)}"),
      ],
    );

    List<Widget> cardsProduct =
        (history["items"] as List).map<Widget>((product) {
          return CardProduct(product: product);
        }).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.menu,
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 0.2, blurRadius: 8),
        ],
      ),
      child:
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  historyInfo,
                  Center(child: Wrap(children: cardsProduct)),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  historyInfo,
                  Expanded(
                    child: CarouselSlider(
                      items: cardsProduct,
                      options: CarouselOptions(
                        height: 200,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.3,
                        padEnds: false,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
