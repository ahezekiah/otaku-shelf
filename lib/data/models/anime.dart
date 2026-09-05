class Anime {
  final int malId;
  final String title;
  final String? imageUrl;
  final double? score;

  Anime({
    required this.malId,
    required this.title,
    this.imageUrl,
    this.score,
  });

  factory Anime.fromJson(Map<String, dynamic> j) => Anime(
    malId: j['mal_id'],
    title: j['title'] ?? 'Untitled',
    imageUrl: j['images']?['jpg']?['image_url'],
    score: (j['score'] as num?)?.toDouble(),
  );
}

