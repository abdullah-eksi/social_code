import 'package:flutter/material.dart';
import '/models/feed_model.dart';
import '/models/user_model.dart';
import '/service/user_service.dart';
import '/service/tag_service.dart';
class FeedCard extends StatelessWidget {
  final FeedModel feed;
  final VoidCallback? onTap;
  final UserService userService = UserService();

  FeedCard({super.key, required this.feed, this.onTap});

  Future<UserModel?> _getAuthor() async {
    try {
      // authorId değerini kullanarak kullanıcı bilgilerini alalım
      final author = await userService.getUserById(feed.authorId);
      if (author != null) {
        return author;
      }
      
      // Eğer direkt ID ile bulamazsak, tüm kullanıcıları tarayalım
      final users = await userService.getUsers();
      return users.firstWhere(
        (u) => u.userId == feed.authorId,
        orElse: () => UserModel(
          userId: "0",
          name: "Unknown",
          username: "@unknown",
          email: "",
          status: "offline",
          description: "",
          avatarUrl: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(), password: '',
        ),
      );
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<UserModel?>(
      future: _getAuthor(),
      builder: (context, snapshot) {
        final author = snapshot.data;

        return Card(
          color: theme.cardColor, // Açık mavi-gri tonu arka plan rengi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Yazar ve tarih
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: author != null && author.avatarUrl.isNotEmpty
                            ? NetworkImage(author.avatarUrl)
                            : null,
                        child: author == null || author.avatarUrl.isEmpty
                            ? const Icon(Icons.person, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author?.name ?? "Kullanıcı",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              author?.username ?? "@kullanıcı",
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${feed.createdAt.day}/${feed.createdAt.month}/${feed.createdAt.year}",
                        style: TextStyle(color: theme.hintColor, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Başlık
                  Text(
                    feed.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Tag'ler
                  if (feed.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: feed.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withAlpha(26), // 0.1 -> withAlpha(0.1*255=26)
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.primaryColor.withAlpha(77)), // 0.3 -> withAlpha(0.3*255=77)
                            ),
                            child: Text(
                              '#${TagService().getTagById(tag)?.name ?? "tag"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  // İçerik
                  Text(
                    feed.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor),
                  ),
                  const SizedBox(height: 10),
                  // Resimler
                  if (feed.images.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: feed.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              feed.images[index],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  if (feed.images.isNotEmpty) const SizedBox(height: 10),
                  // Like / Favorite / Repost
                  Row(
                    children: [
                      Icon(Icons.thumb_up, size: 18, color: theme.primaryColor),
                      const SizedBox(width: 4),
                      Text("${feed.likesCount}"),
                      const SizedBox(width: 16),
                      Icon(Icons.favorite, size: 18, color: Colors.red),
                      const SizedBox(width: 4),
                      Text("${feed.favoritesCount}"),
                      const SizedBox(width: 16),
                      Icon(Icons.repeat, size: 18, color: Colors.green),
                      const SizedBox(width: 4),
                      Text("${feed.repostsCount}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
