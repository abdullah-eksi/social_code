
import '/routes.dart';

import '/controllers/home/home_controller.dart'; // HomeController'ı kullanıyoruz, profil için ayrı controller oluşturulabilir

class ProfileView extends StatefulWidget {
  final String? userId;
  
  const ProfileView({super.key, this.userId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _animationController;

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
    
    // Profil verilerini yükle
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Profil verilerini yükleme işlemi burada yapılabilir
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
                    children: [
                      // Profil içeriği burada yer alacak
                      Text(
                        "Profil Sayfası",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text("Kullanıcı ID: ${widget.userId ?? 'Belirtilmedi'}"),
                      // Profil detayları buraya eklenebilir
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
                                  Text("Son Aktiviteler", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ListTile(title: Text("Aktivite 1")),
                                  ListTile(title: Text("Aktivite 2")),
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
