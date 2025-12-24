class HomeNews {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String category;

  HomeNews({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.category,
  });

  factory HomeNews.fromJson(Map<String, dynamic> json) {
    return HomeNews(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? 'https://placehold.co/600x400?text=No+Image',
      source: json['source']['name'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      category: 'General',
    );
  }
}
