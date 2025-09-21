import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int? totalComments; // Agora é opcional

  const StarRating({
    super.key,
    required this.rating,
    this.totalComments, // Não é obrigatório
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index + 1 <= rating) {
            return Icon(Icons.star, color: AppColors.blue);
          } else if (index + 0.5 <= rating) {
            return Icon(Icons.star_half, color: AppColors.blue);
          } else {
            return Icon(Icons.star_border, color: AppColors.blue);
          }
        }),
        Text(
          totalComments != null
              ? "${rating.toStringAsFixed(1)} ($totalComments)"
              : rating.toStringAsFixed(1),
          style: TextStyle(color: AppColors.blue),
        ),
      ],
    );
  }
}
