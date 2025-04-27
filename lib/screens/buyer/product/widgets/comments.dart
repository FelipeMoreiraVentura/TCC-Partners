import 'package:flutter/material.dart';
import 'package:market_partners/screens/buyer/product/widgets/stars_rating.dart';
import 'package:market_partners/utils/is_mobile.dart';
import 'package:market_partners/utils/style.dart';

class Comments extends StatelessWidget {
  final List<Map<String, dynamic>> comments;
  final Map<String, num> rating;

  const Comments({super.key, required this.comments, required this.rating});

  @override
  Widget build(BuildContext context) {
    bool isMobile = IsMobile(context);

    int totalComments = comments.length;
    Column avalityStatus = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StarRating(rating: rating),
        ...List.generate(5, (index) {
          int amount =
              comments
                  .where((comment) => comment['rating'] == index + 1)
                  .length;
          double percentage = totalComments == 0 ? 0 : amount / totalComments;

          return Row(
            children: [
              Text("${index + 1}"),
              Icon(Icons.star, size: 20, color: Colors.grey),
              SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  value: percentage,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        }),
      ],
    );

    Column usersComments = Column(
      children:
          comments.map((comment) {
            return Card(
              child: ListTile(
                title: Text(comment["user"]),
                subtitle: Text(comment["comment"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(comment["rating"].toString()),
                  ],
                ),
              ),
            );
          }).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Avaliações", style: AppText.titleInfoMedium),
        isMobile
            ? Column(children: [avalityStatus, usersComments])
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avalityStatus,
                Expanded(
                  child: SizedBox(
                    height: 300,
                    child: SingleChildScrollView(child: usersComments),
                  ),
                ),
              ],
            ),
      ],
    );
  }
}
