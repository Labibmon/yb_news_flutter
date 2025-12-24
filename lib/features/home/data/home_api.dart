import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../domain/home_model.dart';

class HomeApi {
  static Future<List<HomeNews>> fetchTopHeadlines({
    String category = 'general',
    String query = '',
    String max = '10',
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}'
      '?country=us'
      '&lang=en'
      '&max=$max'
      '&category=$category'
      '&q=$query'
      '&apikey=${ApiConfig.newsApiKey}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load news');
    }

    final data = jsonDecode(response.body);
    final List articles = data['articles'];

    return articles.map((json) => HomeNews.fromJson(json)).toList();
  }
}
