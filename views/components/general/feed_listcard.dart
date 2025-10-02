import 'package:flutter/material.dart';
import '/service/feed_service.dart';
import '/service/tag_service.dart';
import '/models/feed_model.dart';
import 'feed_card.dart';

class FeedListWidget extends StatefulWidget {
  final int selectedCategoryIndex;
  
  const FeedListWidget({
    super.key, 
    this.selectedCategoryIndex = 0,
  });

  @override
  State<FeedListWidget> createState() => _FeedListWidgetState();
}

class _FeedListWidgetState extends State<FeedListWidget> {
  final feedService = FeedService();
  final tagService = TagService();
  Future<List<FeedModel>> _feedsFuture = Future.value([]);
  late int _currentCategory;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategoryIndex;
    _loadFeeds();
  }
  
  @override
  void didUpdateWidget(FeedListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kategori değiştiğinde ya da aynı kategoriye tekrar tıklandığında güncelle
    if (widget.selectedCategoryIndex != oldWidget.selectedCategoryIndex) {
      setState(() {
        _currentCategory = widget.selectedCategoryIndex;
        _loadFeeds();
      });
    } else if (widget.selectedCategoryIndex == _currentCategory) {
      // Aynı kategoriye tekrar tıklanırsa da içeriği yenile
      _refreshFeeds();
    }
  }
  
  // İçeriği yenilemek için kullanılan metod
  void _refreshFeeds() {
    setState(() {
      _loadFeeds();
    });
  }
  
  // Title'dan SEF URL oluşturma
String createSefFromTitle(String title) {
  // Türkçe karakterleri çevir
  const turkishChars = {
    'ç': 'c',
    'Ç': 'c',
    'ğ': 'g',
    'Ğ': 'g',
    'ı': 'i',
    'İ': 'i',
    'ö': 'o',
    'Ö': 'o',
    'ş': 's',
    'Ş': 's',
    'ü': 'u',
    'Ü': 'u',
  };

  turkishChars.forEach((key, value) {
    title = title.replaceAll(key, value);
  });

  // Küçük harfe çevir
  title = title.toLowerCase();

  // Sadece alfanümerik ve boşlukları bırak
  title = title.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');

  // Boşlukları tire ile değiştir
  title = title.replaceAll(RegExp(r'\s+'), '-');

  // Birden fazla tireyi tek tireye indir
  title = title.replaceAll(RegExp(r'-+'), '-');

  // Başta ve sonda tire varsa temizle
  title = title.replaceAll(RegExp(r'^-+|-+$'), '');

  return title;
}

  
  void _loadFeeds() {
    // Kategori indeksine göre farklı feed listelerini yükle
    if (_currentCategory == 0) {
      // Ana sayfa - normal feedler
      _feedsFuture = feedService.getFeeds();
    } else if (_currentCategory == 1) {
      // Sana Özel - random feedler
      _feedsFuture = feedService.getRandomFeeds();
    } else if (_currentCategory == 2) {
      // Popüler - en çok beğeni ve repost alanlar
      _feedsFuture = feedService.getPopularFeeds();
    } else {
      // Diğer kategoriler - tag ID'ye göre filtrele
      _getTagFeeds(_currentCategory);
    }
  }
  
  void _getTagFeeds(int categoryIndex) async {
    // Kategori indeksine karşılık gelen tag ID'sini bul ve ona göre feedleri yükle
    try {
      final tags = await tagService.getTags();
      if (categoryIndex - 3 < tags.length) {
        // 3 çıkarıyoruz çünkü ilk 3 kategori özel (Anasayfa, Sana Özel, Popüler)
        final tagId = tags[categoryIndex - 3].id;
        _feedsFuture = feedService.getFeedsByTag(tagId);
      } else {
        // Eşleşen tag yoksa normal feedleri göster
        _feedsFuture = feedService.getFeeds();
      }
    } catch (e) {
      debugPrint("Tag yüklenirken hata: $e");
      _feedsFuture = feedService.getFeeds(); // Hata durumunda normal feedler
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeedModel>>(
      future: _feedsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Feedler yüklenemedi",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Henüz feed yok"));
        }

        final feeds = snapshot.data!;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          itemCount: feeds.length,
          itemBuilder: (context, index) {
            final feed = feeds[index];
            return FeedCard(
              feed: feed,
              onTap: () {
                // SEF URL oluştur (title'dan URL-friendly string)
                final sefUrl = createSefFromTitle(feed.title);
                debugPrint("Feed tıklandı: ${feed.title} (SEF: $sefUrl)");
                
                // Feed detay sayfasına yönlendirme
                Navigator.of(context).pushNamed('/feed_detail/$sefUrl');
              },
            );
          },
        );
      },
    );
  }
}
