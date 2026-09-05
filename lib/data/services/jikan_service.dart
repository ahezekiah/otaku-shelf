import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class JikanService {
  static Future<List<Anime>> topAnime() async {
    final uri = Uri.parse('https://api.jikan.moe/v4/top/anime?limit=20');
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['data'] as List?) ?? [];
    return list.map((d) => Anime.fromJson(d as Map<String, dynamic>)).toList();
  }
}
