import 'package:flutter/material.dart';
import '../data/home_repository.dart';
import '../domain/home_model.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();

  bool isLoadingTrending = false;
  bool isLoadingNews = false;
  List<HomeNews> trending = [];
  List<HomeNews> news = [];

  Future<void> loadTrending({String category = '', String query = ''}) async {
    isLoadingTrending = true;
    notifyListeners();

    try {
      trending = await _repo.getTopHeadlines(
        category: category,
        query: query,
        max: "1",
      );
    } catch (e) {
      trending = [];
    }

    isLoadingTrending = false;
    notifyListeners();
  }

  Future<void> loadNews({
    String category = 'general',
    String query = '',
  }) async {
    isLoadingNews = true;
    notifyListeners();

    try {
      news = await _repo.getNews(category: category, query: query, max: "10");
    } catch (e) {
      news = [];
    }

    isLoadingNews = false;
    notifyListeners();
  }
}
