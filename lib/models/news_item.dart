class NewsItem {
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime date;
  final String url;

  NewsItem({
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      date: DateTime.parse(json['date'] as String),
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'url': url,
    };
  }
} 