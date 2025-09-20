import 'package:flutter/material.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/utils/style.dart';
import 'package:market_partners/utils/translate.dart';
import 'package:market_partners/widgets/input.dart';
import 'package:market_partners/widgets/my_filled_button.dart';
import 'package:market_partners/widgets/stars_rating.dart';

class ViewReview extends StatefulWidget {
  final ReviewsModels? review;
  final bool showSellerResponseField;
  final void Function(String)? onRespond;

  const ViewReview({
    super.key,
    required this.review,
    this.showSellerResponseField = false,
    this.onRespond,
  });

  @override
  State<ViewReview> createState() => _ViewReviewState();
}

class _ViewReviewState extends State<ViewReview> {
  final TextEditingController sellerCommentController = TextEditingController();

  @override
  void dispose() {
    sellerCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    if (review == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.menu,
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
              // --- Avaliação do comprador ---
              Row(
                children: [
                  const Icon(Icons.person, color: AppColors.blue),
                  const SizedBox(width: 8),
                  TranslatedText(
                    text: "Sua Avaliação",
                    style: AppText.titleTiny,
                  ),
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
                    StarRating(rating: review.rating.toDouble()),
                    const SizedBox(height: 6),
                    Text(review.buyerComment, style: AppText.base),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.storefront, color: AppColors.blue),
                  const SizedBox(width: 8),
                  TranslatedText(
                    text:
                        widget.showSellerResponseField
                            ? "Sua resposta"
                            : "Resposta do vendedor",
                    style: AppText.titleTiny,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              if (review.sellerComment.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.menuBackground,
                        width: 3,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: TranslatedText(
                    text: review.sellerComment,
                    style: AppText.base,
                  ),
                )
              else if (widget.showSellerResponseField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Input(
                      label: "none",
                      type: InputType.text,
                      controller: sellerCommentController,
                      validation: false,
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: MyFilledButton(
                        child: TranslatedText(
                          text: "Enviar reposta",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (widget.onRespond != null &&
                              sellerCommentController.text.trim().isNotEmpty) {
                            widget.onRespond!(
                              sellerCommentController.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )
              else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.menuBackground,
                        width: 3,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: const TranslatedText(text: "—", style: AppText.base),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
