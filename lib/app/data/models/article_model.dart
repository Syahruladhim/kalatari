class Article {
  final String id;
  final String title;
  final String date;
  final String link;
  final String category;
  final String content;
  final List<String> imageUrls;

  Article({
    required this.id,
    required this.title,
    required this.date,
    required this.link,
    required this.category,
    required this.content,
    required this.imageUrls,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      link: json['link'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}
