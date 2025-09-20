import 'package:flutter/material.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/screens/buyer_seller/purchase/widgets/rating_button.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/toast.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/my_filled_button.dart';

class Review extends StatefulWidget {
  final ReviewsModels? review;
  final void Function(String comment, int rating) addReview;

  const Review({super.key, required this.review, required this.addReview});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  TextEditingController avality = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Cabeçalho
          Row(
            children: [
              const Icon(Icons.person, color: AppColors.blue),
              const SizedBox(width: 8),
              TranslatedText(text: "Sua Avaliação", style: AppText.titleTiny),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingButton(
                  initialRating: 0,
                  onRatingSelected: (r) {
                    setState(() {
                      rating = r;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Input(
                  type: InputType.text,
                  label: "Avaliação",
                  controller: avality,
                  validation: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: MyFilledButton(
              onPressed: () {
                if (avality.text.trim().isEmpty || rating == 0) {
                  ToastService.error("Preencha a avaliação e escolha uma nota");
                  return;
                }
                widget.addReview(avality.text.trim(), rating);
              },
              child: TranslatedText(
                text: "Salvar",
                style: AppText.base.apply(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
