import '../domain/home_model.dart';
import 'home_api.dart';

class HomeRepository {
  Future<List<HomeNews>> getTopHeadlines({
    String category = 'general',
    String query = '',
    String max = '10',
  }) {
    return HomeApi.fetchTopHeadlines(
      category: category,
      query: query,
      max: max,
    );
  }

  Future<List<HomeNews>> getNews({
    String category = 'general',
    String query = '',
    String max = '10',
  }) {
    return HomeApi.fetchTopHeadlines(
      category: category,
      query: query,
      max: max,
    );
  }
}
