class Book {
  final String key;
  final String title;
  final String? author;
  final int? firstYear;
  final int? coverId;

  Book({
    required this.key,
    required this.title,
    this.author,
    this.firstYear,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> j) => Book(
    key: j['key'] ?? '',
    title: j['title'] ?? 'Untitled',
    author: (j['author_name'] as List?)?.cast<String>().firstOrNull,
    firstYear: j['first_publish_year'],
    coverId: j['cover_i'],
  );

  String? get coverUrl =>
      coverId == null ? null : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
