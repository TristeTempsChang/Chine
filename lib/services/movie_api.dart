import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApi {
  static const String _apiKey = '2bc9907efccdbcc44d713a5725bc05c3';

  static Future<List<Movie>> fetchPopular({int page = 1}) async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/movie/popular',
      <String, String>{
        'api_key': _apiKey,
        'language': 'fr',
        'page': '$page',
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Erreur API: ${res.statusCode} ${res.body}');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List<dynamic>)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();

    return results;
  }

  static Future<Movie?> fetchById(int id) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=TON_API_KEY&language=fr-FR');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Movie.fromJson(json);
    } else {
      return null;
    }
  }
}
