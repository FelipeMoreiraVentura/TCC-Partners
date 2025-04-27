import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class StarRating extends StatelessWidget {
  final Map<String, num> rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    num count = rating["count"] ?? 0;
    num average = rating["average"] ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index + 1 <= average) {
            return Icon(Icons.star, color: AppColors.blue);
          } else if (index + 0.5 <= average) {
            return Icon(Icons.star_half, color: AppColors.blue);
          } else {
            return Icon(Icons.star_border, color: AppColors.blue);
          }
        }),
        Text("${average.toString()} (${count.toString()})"),
      ],
    );
  }
}
