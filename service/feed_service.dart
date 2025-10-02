import '../models/feed_model.dart';
import '../models/user_model.dart';
import '../service/user_service.dart';
import '../service/tag_service.dart';
import 'dart:math';

class FeedService {
  final UserService userService = UserService();
  final TagService tagService = TagService();

  Future<List<FeedModel>> getFeeds() async {
    return _generateFeeds();
  }

  /// Random sıralı feed listesi
  Future<List<FeedModel>> getRandomFeeds() async {
    final feeds = await _generateFeeds();
    feeds.shuffle(Random());
    return feeds;
  }

  /// Popüler feedler (en çok like + repost toplamına göre)
  Future<List<FeedModel>> getPopularFeeds() async {
    final feeds = await _generateFeeds();
    feeds.sort((a, b) {
      int aScore = a.likesCount + a.repostsCount;
      int bScore = b.likesCount + b.repostsCount;
      return bScore.compareTo(aScore);
    });
    return feeds;
  }

  /// Tag ID’ye göre filtrelenmiş feedler
  Future<List<FeedModel>> getFeedsByTag(int tagId) async {
    final feeds = await _generateFeeds();
    return feeds.where((f) => f.tags.contains(tagId)).toList();
  }

  /// Belirli userId’ye göre filtrelenmiş feedler
  Future<List<FeedModel>> getFeedsByUser(String userId) async {
    final feeds = await _generateFeeds();
    return feeds.where((f) => f.authorId == userId).toList();
  }

  /// --- Özel method: Tüm feedleri oluşturur ---
  Future<List<FeedModel>> _generateFeeds() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Kullanıcıları çek
      final users = await userService.getUsers();
      final safeUsers = users.isNotEmpty
          ? users
          : [
              UserModel(
                userId: "0",
                name: "Unknown",
                username: "@unknown",
                email: "",
                password: "",
                status: "offline",
                description: "",
                avatarUrl: "",
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ];

      // Tag'ları al
   

      List<Map<String, dynamic>> feedsData = [
        {
          "title": "Flutter State Management Tartışması",
          "content":
              "Bence Provider kullanmak yeterli, Riverpod çok mu abartılıyor? Siz ne düşünüyorsunuz?",
          "images": [
            "https://picsum.photos/200/300",
            "https://picsum.photos/201/300",
          ],
          "videos": [],
          "authorId": "1", // Abdullah Ekşi
          "likes": [2, 3, 4], // Elif, Mehmet, Zeynep
          "favorites": [2],
          "reposts": [],
          "tags": [12, 13, 22], // Flutter, Dart, TypeScript
          "createdAt": DateTime.now().subtract(const Duration(hours: 5)),
        },
        {
          "title": "Dart Null Safety Gerçekten Gerekli mi?",
          "content":
              "Null safety kodu daha güvenli yapıyor ama bazı paketlerde sorun çıkabiliyor. Deneyenler yorumlar?",
          "images": [],
          "videos": [],
          "authorId": "2", // Elif Yılmaz
          "likes": [1, 4], // Abdullah, Zeynep
          "favorites": [1],
          "reposts": [3],
          "tags": [13, 5, 12], // Dart, Yazılım, Flutter
          "createdAt": DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          "title": "Laravel vs Node.js Backend Karşılaştırması",
          "content":
              "Node.js asenkron yapısı ile çok hızlı ama Laravel stabil ve uzun ömürlü projelerde güvenilir.",
          "images": ["https://picsum.photos/202/300"],
          "videos": [],
          "authorId": "3", // Mehmet Kaya
          "likes": [1, 4], // Abdullah, Zeynep
          "favorites": [],
          "reposts": [2],
          "tags": [9, 7, 14], // Php, Web, JavaScript
          "createdAt": DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          "title": "React Native mi Flutter mı?",
          "content":
              "Mobil uygulama için Flutter daha hızlı derleniyor, JS ekosistemi büyük ve daha fazla paket var.",
          "images": [
            "https://picsum.photos/203/300",
            "https://picsum.photos/204/300",
          ],
          "videos": [
            "https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_1mb.mp4",
          ],
          "authorId": "4", // Zeynep Demir
          "likes": [1, 2, 3], // Abdullah, Elif, Mehmet
          "favorites": [1],
          "reposts": [3],
          "tags": [12, 6, 14], // Flutter, Mobil, JavaScript
          "createdAt": DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          "title": "Python ile Yapay Zeka Projeleri",
          "content":
              "TensorFlow ve PyTorch arasında kaldım. Hangisini öğrenmeliyim? Yeni başlayanlar için tavsiyeleriniz neler?",
          "images": [
            "https://picsum.photos/205/300",
            "https://picsum.photos/206/300",
            "https://picsum.photos/207/300",
          ],
          "videos": [],
          "authorId": "1", // Abdullah Ekşi
          "likes": [2, 3, 4],
          "favorites": [2, 3],
          "reposts": [4],
          "tags": [11, 5, 8], // Python, Yazılım, Siber Güvenlik
          "createdAt": DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          "title": "Web Assembly Geleceği",
          "content":
              "Web Assembly ile C++ ve Rust kodları browser'da çalıştırılabiliyor. Bu teknoloji web development'ı tamamen değiştirebilir mi?",
          "images": [],
          "videos": [
            "https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_2mb.mp4",
          ],
          "authorId": "2", // Elif Yılmaz
          "likes": [1, 3, 4],
          "favorites": [1, 4],
          "reposts": [3],
          "tags": [15, 16, 7], // C#, C++, Web
          "createdAt": DateTime.now().subtract(
            const Duration(days: 1, hours: 3),
          ),
        },
        {
          "title": "Mobil Uygulama Tasarım Trendleri 2024",
          "content":
              "Bu yıl neomodorfizm ve glassmorphism stilleri öne çıkıyor. Karanlık mod desteği artık zorunlu hale geldi.",
          "images": ["https://picsum.photos/208/300"],
          "videos": [],
          "authorId": "3", // Mehmet Kaya
          "likes": [1, 2, 4],
          "favorites": [2, 4],
          "reposts": [1, 4],
          "tags": [6, 18, 19], // Mobil, Swift, Kotlin
          "createdAt": DateTime.now().subtract(const Duration(days: 4)),
        },
        {
          "title": "Database Seçimi: SQL vs NoSQL",
          "content":
              "Projem için PostgreSQL mi yoksa MongoDB mi kullanmalıyım? İlişkisel veriler için SQL daha iyi ama NoSQL daha esnek.",
          "images": [
            "https://picsum.photos/209/300",
            "https://picsum.photos/210/300",
          ],
          "videos": [],
          "authorId": "4", // Zeynep Demir
          "likes": [1, 2],
          "favorites": [3],
          "reposts": [2],
          "tags": [10, 20, 5], // Java, Go, Yazılım
          "createdAt": DateTime.now().subtract(const Duration(days: 5)),
        },
        {
          "title": "Clean Architecture Uygulama Deneyimim",
          "content":
              "Clean Architecture ile proje geliştirdim. İlk başta karmaşık geldi ama uzun vadede kod bakımı çok daha kolay oldu.",
          "images": [],
          "videos": [],
          "authorId": "1", // Abdullah Ekşi
          "likes": [2, 3, 4],
          "favorites": [2, 3, 4],
          "reposts": [2, 3],
          "tags": [21, 5, 12], // Rust, Yazılım, Flutter
          "createdAt": DateTime.now().subtract(const Duration(days: 6)),
        },
        {
          "title": "GitHub Copilot Üretkenliği Arttırıyor mu?",
          "content":
              "AI destekli kod tamamlama gerçekten zaman kazandırıyor mu? Yoksa bağımlılık yapıp programlama becerilerini köreltiyor mu?",
          "images": ["https://picsum.photos/211/300"],
          "videos": [
            "https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_3mb.mp4",
          ],
          "authorId": "2", // Elif Yılmaz
          "likes": [1, 3, 4],
          "favorites": [1],
          "reposts": [4],
          "tags": [23, 24, 5], // HTML, CSS, Yazılım
          "createdAt": DateTime.now().subtract(const Duration(days: 7)),
        },
        {
          "title": "Microservices Mimarisinde Zorluklar",
          "content":
              "Microservices dağıtık sistemlerde güçlü ama monitoring ve debugging zorlaşıyor. Service mesh çözümleri işe yarıyor mu?",
          "images": [
            "https://picsum.photos/212/300",
            "https://picsum.photos/213/300",
            "https://picsum.photos/214/300",
          ],
          "videos": [],
          "authorId": "3", // Mehmet Kaya
          "likes": [1, 4],
          "favorites": [1, 2],
          "reposts": [4],
          "tags": [7, 14, 10], // Web, JavaScript, Java
          "createdAt": DateTime.now().subtract(const Duration(days: 8)),
        },
        {
          "title":
              "JavaScript Framework Karşılaştırması: React vs Vue vs Angular",
          "content":
              "2024'te hangi framework'ü öğrenmeli? React en popüler, Vue en kolay, Angular enterprise projelerde güçlü.",
          "images": ["https://picsum.photos/215/300"],
          "videos": [],
          "authorId": "4", // Zeynep Demir
          "likes": [1, 2, 3],
          "favorites": [1, 2],
          "reposts": [1, 3],
          "tags": [14, 7, 22], // JavaScript, Web, TypeScript
          "createdAt": DateTime.now().subtract(const Duration(days: 9)),
        },
        {
          "title": "Kotlin Multiplatform Deneyimlerim",
          "content":
              "Kotlin Multiplatform ile iOS ve Android için aynı business logic'i paylaşıyorum. Performans ve stabilite beklediğim kadar iyi.",
          "images": [
            "https://picsum.photos/216/300",
            "https://picsum.photos/217/300",
          ],
          "videos": [
            "https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_4mb.mp4",
          ],
          "authorId": "1", // Abdullah Ekşi
          "likes": [2, 3, 4],
          "favorites": [2],
          "reposts": [3],
          "tags": [19, 6, 18], // Kotlin, Mobil, Swift
          "createdAt": DateTime.now().subtract(const Duration(days: 10)),
        },
        {
          "title": "Cloud Computing: AWS vs Azure vs Google Cloud",
          "content":
              "Bulut servis sağlayıcıları arasında nasıl seçim yapmalı? AWS en olgun, Azure enterprise entegrasyonda iyi, GCP AI/ML'de güçlü.",
          "images": [],
          "videos": [],
          "authorId": "2", // Elif Yılmaz
          "likes": [1, 3, 4],
          "favorites": [1, 4],
          "reposts": [3],
          "tags": [5, 11, 20], // Yazılım, Python, Go
          "createdAt": DateTime.now().subtract(const Duration(days: 11)),
        },
        {
          "title": "Open Source Projelere Katkıda Bulunmak",
          "content":
              "İlk open source katkımı yaptım! Yeni başlayanlar için nasıl issue bulabileceklerini ve PR açacaklarını anlatıyorum.",
          "images": ["https://picsum.photos/218/300"],
          "videos": [],
          "authorId": "3", // Mehmet Kaya
          "likes": [1, 2, 4],
          "favorites": [1, 2, 4],
          "reposts": [1, 2],
          "tags": [5, 8, 13], // Yazılım, Siber Güvenlik, Dart
          "createdAt": DateTime.now().subtract(const Duration(days: 12)),
        },
      ];

      // FeedModel oluştur
      List<FeedModel> feeds = feedsData.map((f) {
        UserModel author = safeUsers.firstWhere(
          (u) => u.userId == f["authorId"],
          orElse: () => safeUsers.first,
        );

        return FeedModel(
          authorId: f["authorId"] ?? "0",
          title: f["title"] ?? "Başlıksız konu",
          content: f["content"] ?? "",
          images: List<String>.from(f["images"] ?? []),
          videos: List<String>.from(f["videos"] ?? []),
          author: author.name,
          tags: List<int>.from(f["tags"] ?? []),
          likes: List<int>.from(f["likes"] ?? []),
          favorites: List<int>.from(f["favorites"] ?? []),
          reposts: List<int>.from(f["reposts"] ?? []),
          likesCount: (f["likes"] as List?)?.length ?? 0,
          favoritesCount: (f["favorites"] as List?)?.length ?? 0,
          repostsCount: (f["reposts"] as List?)?.length ?? 0,
          createdAt: f["createdAt"] ?? DateTime.now(),
          updatedAt: DateTime.now(),
          publishedAt: f["createdAt"] ?? DateTime.now(),
        );
      }).toList();

      return feeds;
    } catch (e) {
      // Hata durumunda boş liste dön
      return [];
    }
  }

  Future<void> likeFeed(FeedModel feed, int userId) async {
    if (!feed.likes.contains(userId)) {
      feed.likes.add(userId);
      feed.likesCount = feed.likes.length;
    }
  }
}
