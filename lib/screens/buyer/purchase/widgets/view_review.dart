import 'package:flutter/material.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/widgets/stars_rating.dart';

class ViewReview extends StatelessWidget {
  final ReviewsModels? review;
  const ViewReview({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    if (review == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.menu, // branco
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: AppColors.blue),
                  const SizedBox(width: 8),
                  Text("Sua Avaliação", style: AppText.titleTiny),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.menuBackground, width: 3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarRating(rating: review!.rating.toDouble()),
                    const SizedBox(height: 6),
                    Text(review!.buyerComment, style: AppText.base),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.storefront, color: AppColors.blue),
                  const SizedBox(width: 8),
                  Text("Resposta do vendedor", style: AppText.titleTiny),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.menuBackground, width: 3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(review?.sellerComment ?? "—", style: AppText.base),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
