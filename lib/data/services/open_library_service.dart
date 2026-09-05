import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryService {
  static Future<List<Book>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.parse(
        'https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&limit=20');
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    final docs = (data['docs'] as List?) ?? [];
    return docs.map((d) => Book.fromJson(d as Map<String, dynamic>)).toList();
  }
}
