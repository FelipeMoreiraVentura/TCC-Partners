import 'package:flutter/material.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';

class ProductSpecifications extends StatelessWidget {
  final Map<String, dynamic> specifications;
  const ProductSpecifications({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);
    double spacing = MediaQuery.of(context).size.width * 0.15;

    List<Widget> specificationsList =
        specifications.entries.map((entry) {
          String key = entry.key;
          String value = entry.value.toString();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(text: "$key: ", style: AppText.md),
              TranslatedText(text: value, style: AppText.sm),
            ],
          );
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(text: "Especificações", style: AppText.titleInfoMedium),
        isMobile
            ? Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: specificationsList,
            )
            : Wrap(
              spacing: spacing,
              runSpacing: 8,
              runAlignment: WrapAlignment.spaceBetween,
              children: specificationsList,
            ),
      ],
    );
  }
}
