import 'package:flutter/material.dart';
import 'package:market_partners/models/reviews.dart';
import 'package:market_partners/widgets/stars_rating.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class Comments extends StatelessWidget {
  final List<ReviewsModels>? reviews;

  const Comments({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = IsMobile(context);
    final bool hasReviews = reviews != null && reviews!.isNotEmpty;

    if (!hasReviews) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Avaliações", style: AppText.titleInfoMedium),
          const SizedBox(height: 8),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StarRating(rating: 0.0),
                const SizedBox(width: 8),
                Text("Sem avaliações", style: AppText.base),
              ],
            ),
          ),
        ],
      );
    }

    final int totalComments = reviews!.length;
    final double average =
        reviews!.fold<int>(0, (acc, r) => acc + r.rating) / totalComments;

    Column avalityStatus = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StarRating(rating: average),
            const SizedBox(width: 8),
            Text(
              "${average.toStringAsFixed(1)} ($totalComments)",
              style: AppText.base,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (i) {
          final int stars = 5 - i;
          final int amount = reviews!.where((r) => r.rating == stars).length;
          final double percentage =
              totalComments == 0 ? 0.0 : amount / totalComments;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 28, child: Text("$stars", style: AppText.base)),
                const Icon(Icons.star, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: AppColors.menuBackground.withOpacity(.3),
                      color: AppColors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(
                    amount.toString(),
                    textAlign: TextAlign.right,
                    style: AppText.sm,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );

    Column usersComments = Column(
      children:
          reviews!.map((r) {
            final bool hasSellerReply = r.sellerComment.trim().isNotEmpty;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
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
                  Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.blue),
                      const SizedBox(width: 8),
                      Text("Comprador", style: AppText.titleTiny),
                      const Spacer(),
                      StarRating(rating: r.rating.toDouble()),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                    child: Text(
                      r.buyerComment.isEmpty ? "—" : r.buyerComment,
                      style: AppText.base.copyWith(
                        color: AppText.description.color,
                      ),
                    ),
                  ),
                  if (hasSellerReply) ...[
                    const SizedBox(height: 6),
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.storefront,
                          color: AppColors.blue,
                        ),
                        title: Text(
                          "Resposta do vendedor",
                          style: AppText.titleTiny,
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(r.sellerComment, style: AppText.base),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Avaliações", style: AppText.titleInfoMedium),
        const SizedBox(height: 8),
        isMobile
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avalityStatus,
                const SizedBox(height: 12),
                usersComments,
              ],
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 360, child: avalityStatus),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 360,
                    child: SingleChildScrollView(child: usersComments),
                  ),
                ),
              ],
            ),
      ],
    );
  }
}
