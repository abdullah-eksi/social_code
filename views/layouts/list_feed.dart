
import '/routes.dart';

import '/controllers/home/home_controller.dart';


class ListFeedView extends StatefulWidget {
  final String? category;
  
  const ListFeedView({super.key, this.category});

  @override
  State<ListFeedView> createState() => _ListFeedViewState();
}

class _ListFeedViewState extends State<ListFeedView> with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _animationController;
  List<dynamic> feedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    
    // Feed listesini yükle
    _loadFeedList();
  }

  Future<void> _loadFeedList() async {
    // Feed listesini yükleme işlemi burada yapılabilir
    await Future.delayed(Duration(seconds: 1)); // Simüle edilmiş gecikme
    
    // Örnek feed listesi
    feedList = List.generate(10, (index) => {
      "id": "feed_$index",
      "title": "Feed başlığı ${index + 1}",
      "description": "Bu, '${widget.category}' kategorisindeki örnek bir feed içeriğidir.",
      "author": "Yazar $index",
      "date": DateTime.now().subtract(Duration(days: index)),
    });
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1500;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text("SocialCode", style: GoogleFonts.pacifico(fontSize: 28)),
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _controller.toggleSidebar();
                  if (_controller.isSidebarOpen) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
              )
            : null,
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Sol panel masaüstünde görünür
              if (!isMobile)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 350,
                  child: SidebarSocial(profileWidget: Text("Profil")),
                ),

              // Orta içerik
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kategori: ${widget.category ?? 'Tüm İçerikler'}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      
                      if (isLoading)
                        Center(child: CircularProgressIndicator())
                      else if (feedList.isEmpty)
                        Center(child: Text("İçerik bulunamadı"))
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: feedList.length,
                            itemBuilder: (context, index) {
                              final feed = feedList[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  title: Text(feed["title"]),
                                  subtitle: Text(feed["description"]),
                                  trailing: Text(feed["date"].toString().split(' ')[0]),
                                  onTap: () {
                                    // Feed içeriğine tıklama işlemi
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Sağ panel sadece masaüstünde
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Sağ panelde gösterilecek bileşenler
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("Popüler İçerikler", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ListTile(title: Text("Popüler içerik 1")),
                                  ListTile(title: Text("Popüler içerik 2")),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Mobil cihazlarda açılır sidebar - tüm içeriğin üzerinde olması için sonradan ekliyoruz
          if (isMobile)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final slide = 250.0 * _animationController.value;
                return Stack(
                  children: [
                    if (_animationController.value > 0)
                      GestureDetector(
                        onTap: () {
                          _controller.toggleSidebar();
                          _animationController.reverse();
                        },
                        child: Opacity(
                          opacity: _animationController.value * 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(-250 + slide, 0),
                      child: SizedBox(
                        width: 250,
                        child: SidebarSocial(profileWidget: Text("Profil", style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
