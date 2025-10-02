class FeedModel {
  final String title;
  final String content;
  final List<String> images;
  final List<String> videos;
  final String author;
  final String authorId;    // Kullanıcı ID'si
  final List<int> tags;  // Yeni tag alanı

  final List<int> likes;       // userId listesi
  final List<int> favorites;   // userId listesi
  final List<int> reposts;     // userId listesi

  int likesCount;
  int favoritesCount;
  int repostsCount;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt; // date yerine daha net isim

  FeedModel({
    required this.title,
    required this.content,
    required this.images,
    required this.videos,
    required this.author,
    required this.authorId,
    this.tags = const [],     // Varsayılan olarak boş liste
    this.likesCount = 0,
    this.favoritesCount = 0,
    this.repostsCount = 0,
    required this.likes,
    required this.favorites,
    required this.reposts,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });
}
