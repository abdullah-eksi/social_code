
import '/routes.dart';

import '/controllers/home/home_controller.dart';


class SearchResultsView extends StatefulWidget {
  final String? query;
  
  const SearchResultsView({super.key, this.query});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _animationController;
  List<dynamic> searchResults = [];
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
    
    // Arama sonuçlarını yükle
    _loadSearchResults();
  }

  Future<void> _loadSearchResults() async {
    // Arama sonuçlarını yükleme işlemi burada yapılabilir
    await Future.delayed(Duration(seconds: 1)); // Simüle edilmiş gecikme
    
    // Örnek sonuçlar
    searchResults = List.generate(10, (index) => {
      "title": "Arama sonucu ${index + 1} için başlık",
      "description": "Bu, arama teriminiz '${widget.query}' için örnek bir sonuçtur.",
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
                        "Arama Sonuçları: ${widget.query}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      
                      if (isLoading)
                        Center(child: CircularProgressIndicator())
                      else if (searchResults.isEmpty)
                        Center(child: Text("Sonuç bulunamadı"))
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final result = searchResults[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  title: Text(result["title"]),
                                  subtitle: Text(result["description"]),
                                  onTap: () {
                                    // Sonuca tıklama işlemi
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
                                  Text("İlgili Aramalar", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ListTile(title: Text("İlgili arama 1")),
                                  ListTile(title: Text("İlgili arama 2")),
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
