import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageCard extends StatelessWidget {
  final String title, subtitle;
  final String? imageUrl;
  final VoidCallback onTap;
  final Object? heroTag;
  final Widget? footer; // 👈 NEW (e.g., RatingChip)

  const NetworkImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.heroTag,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final img = imageUrl == null
        ? Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_not_supported),
    )
        : CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover, width: double.infinity);

    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: heroTag == null ? img : Hero(tag: heroTag!, child: img),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (footer != null) ...[
              const SizedBox(height: 4),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

