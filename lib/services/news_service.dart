import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_item.dart';

class NewsService {
  static const String _baseUrl = 'https://thecitc.co.za/news/';
  static const String _lastSyncKey = 'last_news_sync';
  static const Duration _syncInterval = Duration(hours: 1);

  Future<List<NewsItem>> getNews() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final newsItems = <NewsItem>[];

        // Find all news articles on the page
        final articles = document.querySelectorAll('.post');
        print('Found ${articles.length} articles');
        
        for (var article in articles) {
          final titleElement = article.querySelector('.entry-title a');
          final contentElement = article.querySelector('.entry-content');
          final dateElement = article.querySelector('.entry-date');
          final imageElement = article.querySelector('.wp-post-image');
          
          if (titleElement != null && contentElement != null) {
            final title = titleElement.text.trim();
            final content = contentElement.text.trim();
            final date = dateElement?.text.trim() ?? DateTime.now().toString();
            final imageUrl = imageElement?.attributes['src'];
            final url = titleElement.attributes['href'] ?? _baseUrl;

            print('Processing article: $title');
            print('URL: $url');
            print('Image URL: $imageUrl');

            newsItems.add(NewsItem(
              title: title,
              content: content,
              imageUrl: imageUrl,
              date: DateTime.parse(date),
              url: url,
            ));
          } else {
            print('Skipping article due to missing required elements');
          }
        }

        print('Total articles processed: ${newsItems.length}');
        // Save the news items to local storage
        await _saveNewsToLocal(newsItems);
        return newsItems;
      }
      print('Failed to fetch news. Status code: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  Future<void> _saveNewsToLocal(List<NewsItem> newsItems) async {
    final prefs = await SharedPreferences.getInstance();
    final newsJson = newsItems.map((item) => item.toJson()).toList();
    await prefs.setString('cached_news', jsonEncode(newsJson));
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<List<NewsItem>> getCachedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final newsJson = prefs.getString('cached_news');
    if (newsJson != null) {
      final List<dynamic> decoded = jsonDecode(newsJson);
      return decoded.map((item) => NewsItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_news');
    await prefs.remove(_lastSyncKey);
  }

  Future<bool> shouldSync() async {
    final prefs = await SharedPreferences.getInstance();
    
    try {
      // Try to get the value as string
      final lastSyncString = prefs.getString(_lastSyncKey);
      if (lastSyncString != null) {
        final lastSyncTime = DateTime.parse(lastSyncString);
        return DateTime.now().difference(lastSyncTime) > _syncInterval;
      }
    } catch (e) {
      // If there's any error (like type mismatch), clear the value
      await clearCache();
    }
    
    return true; // No valid last sync found, should sync
  }
} 