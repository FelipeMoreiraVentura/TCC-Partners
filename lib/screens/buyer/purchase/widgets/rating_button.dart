import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class RatingButton extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingSelected;

  const RatingButton({
    super.key,
    this.initialRating = 0,
    required this.onRatingSelected,
  });

  @override
  State<RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends State<RatingButton> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  Widget _buildStar(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentRating = index;
        });
        widget.onRatingSelected(_currentRating);
      },
      child: Icon(
        index <= _currentRating ? Icons.star : Icons.star_border,
        color: AppColors.blue,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => _buildStar(index + 1)),
    );
  }
}
