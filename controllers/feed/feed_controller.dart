import 'package:flutter/material.dart';
import '/models/feed_model.dart';
import '/service/feed_service.dart';

// Yönlendirme callback fonksiyonu için typedef
typedef RedirectCallback = void Function();

class FeedController extends ChangeNotifier {
  final FeedService _feedService = FeedService();
  FeedModel? feed;
  bool isLoading = true;
  String? error;
  bool isSidebarOpen = false;

  // SEF (Search Engine Friendly) URL oluşturma
  String createSefFromTitle(String title) {
    const turkishChars = {
      'ç': 'c', 'Ç': 'c', 'ğ': 'g', 'Ğ': 'g',
      'ı': 'i', 'İ': 'i', 'ö': 'o', 'Ö': 'o',
      'ş': 's', 'Ş': 's', 'ü': 'u', 'Ü': 'u',
    };
    turkishChars.forEach((key, value) {
      title = title.replaceAll(key, value);
    });
    title = title.toLowerCase();
    title = title.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    title = title.replaceAll(RegExp(r'\s+'), '-');
    title = title.replaceAll(RegExp(r'-+'), '-');
    title = title.replaceAll(RegExp(r'^-+|-+$'), '');
    return title;
  }

  // Feed yükleme işlemi
  Future<void> loadFeed(String? sef, RedirectCallback onRedirect) async {
    if (sef == null || sef.isEmpty) {
      onRedirect();
      return;
    }
    
    // Sayfa yüklenirken başlangıç durumu
    feed = null;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final feeds = await _feedService.getFeeds();
      feed = feeds.firstWhere(
        (f) => createSefFromTitle(f.title) == sef || f.authorId == sef,
        orElse: () => throw Exception("Feed bulunamadı"),
      );
      error = null;
    } catch (e) {
      debugPrint("Feed yüklenemedi: $e");
      error = e.toString();
      onRedirect();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Sidebar durumunu değiştirme (içerik yenilemeden)
  void toggleSidebar() {
    isSidebarOpen = !isSidebarOpen;
    // notifyListeners çağrılmıyor, böylece içerik yenilenmiyor
  }
  
  // Sidebar durumunu döndüren getter
  bool get sidebarOpen => isSidebarOpen;
}
