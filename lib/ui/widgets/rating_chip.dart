import 'package:flutter/material.dart';

class RatingChip extends StatelessWidget {
  final double? score;
  const RatingChip({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    final s = score;
    if (s == null) return const SizedBox.shrink();
    return Chip(
      avatar: const Icon(Icons.star, size: 16),
      label: Text(s.toStringAsFixed(s % 1 == 0 ? 0 : 1)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
