import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'news_service.dart';

class BackgroundSyncService {
  static const String _lastSyncKey = 'last_news_sync';
  static const Duration _syncInterval = Duration(hours: 1);
  static Timer? _syncTimer;

  static Future<void> initialize() async {
    // Cancel any existing timer
    _syncTimer?.cancel();
    
    // Start periodic sync
    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      await _checkAndSync();
    });
    
    // Initial sync
    await _checkAndSync();
  }

  static Future<void> _checkAndSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString(_lastSyncKey);
    
    if (lastSync == null || DateTime.now().difference(DateTime.parse(lastSync)) >= _syncInterval) {
      final newsService = NewsService();
      if (await newsService.shouldSync()) {
        await newsService.getNews();
        await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
      }
    }
  }

  static void dispose() {
    _syncTimer?.cancel();
  }
} 