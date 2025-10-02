import 'package:flutter/material.dart';
import '/service/feed_service.dart';
import '/models/feed_model.dart';

class LastSubjectsWidget extends StatefulWidget {
  final Function(String)? onTap;
  final Function()? onRefresh; // Yenileme fonksiyonu için callback
  final int refreshTrigger; // Yenileme tetikleyicisi
  
  const LastSubjectsWidget({
    super.key, 
    this.onTap, 
    this.onRefresh,
    this.refreshTrigger = 0, // Varsayılan değer
  });

  @override
  State<LastSubjectsWidget> createState() => _LastSubjectsWidgetState();
}

class _LastSubjectsWidgetState extends State<LastSubjectsWidget> {
  final FeedService feedService = FeedService();
  Future<List<FeedModel>> _feedsFuture = Future.value([]);
  int _lastRefreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }
  
  @override
  void didUpdateWidget(LastSubjectsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // RefreshTrigger değiştiğinde verileri yenile
    if (widget.refreshTrigger != _lastRefreshTrigger) {
      _lastRefreshTrigger = widget.refreshTrigger;
      _loadFeeds();
    }
  }
  
  void _loadFeeds() {
    _feedsFuture = feedService.getFeeds();
    _feedsFuture.then((feeds) {
      debugPrint("Feeds loaded: ${feeds.length} items");
    }).catchError((e) {
      debugPrint("Feed load error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<List<FeedModel>>(
        future: _feedsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(
              "Konular yüklenemedi",
              style: TextStyle(color: Colors.red),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Konu bulunamadı");
          }

          final feeds = snapshot.data!;
          final lastFeeds = feeds.take(8).toList();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başlık
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "📌 Son Konular",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  // Feed listesi
                  ...lastFeeds.map((feed) {
                    final title = feed.title;
                    final author = feed.author;
                    final date = "${feed.createdAt.day}/${feed.createdAt.month}/${feed.createdAt.year}";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(38), // 0.15 -> withAlpha(0.15*255=38)
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => widget.onTap?.call(title),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                Icon(Icons.bookmark, size: 18, color: theme.primaryColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "yazar: $author • $date",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.primaryColor.withAlpha(179), // 0.7 -> withAlpha(0.7*255=179)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, size: 20, color: theme.primaryColor.withAlpha(179)), // 0.7 -> withAlpha(0.7*255=179)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 5),
                  // Daha Fazlasını Gör butonu
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        debugPrint("Daha Fazlasını Gör tıklandı!");
                        // İçeriği yenile
                        setState(() {
                          _loadFeeds();
                        });
                        // Callback'i çağır
                        widget.onRefresh?.call();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Yenile"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
