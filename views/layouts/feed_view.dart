
import '/routes.dart';
import '/controllers/feed/feed_controller.dart';


class FeedView extends StatefulWidget {
  final String? sef; // slug / seflink veya ID

  const FeedView({super.key, required this.sef});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with SingleTickerProviderStateMixin {
  final FeedController _feedController = FeedController();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Controller'daki değişiklikleri özel bir şekilde dinle
    _feedController.addListener(() {
      // Eğer sidebar durumu değişirse UI'ı güncelleme
      if (mounted) {
        // Feed veya loading durumu değiştiğinde UI güncellenir
        if (_feedController.feed != null || _feedController.isLoading) {
          setState(() {});
        }
      }
    });

    _loadFeed();
  }

  Future<void> _loadFeed() async {
    await _feedController.loadFeed(widget.sef, _redirectToHome);
  }

  void _redirectToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_feedController.isLoading || _feedController.feed == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1500; // breakpoint

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomTopBar(
          bgColor: Colors.black,
          elevation: 0,
          center: Text("SocialCode", style: GoogleFonts.pacifico(fontSize: 28)),
          left: isMobile
              ? IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // İçeriği yenilemeden sadece sidebar durumunu değiştir
                    _feedController.toggleSidebar();
                    if (_feedController.sidebarOpen) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                )
              : null,
        ),
      ),
      body: Stack(
        children: [
          // Ana içerik - en altta
          Row(
            children: [
              // Sol panel masaüstünde görünür
             if (!isMobile)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 350,
                  child: SidebarSocial(profileWidget: ProfileCard()),
                ),

              // Orta içerik (feed detayları)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeedCard(
                        feed: _feedController.feed!,
                        onTap: () {
                          debugPrint(
                            "FeedCard tıklandı: ${_feedController.feed!.title}",
                          );
                        },
                      ),
                      const SizedBox(height: 50), // Alt kısımda boşluk
                    ],
                  ),
                ),
              ),

              // Sağ panel sadece masaüstünde görünür
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          cSearchInput(
                            context: context,
                            controller: TextEditingController(),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 12),
                          LastSubjectsWidget(),
                          const SizedBox(height: 12),
                          ActiveUsersWidget(),
                          const SizedBox(height: 50), // en altta boşluk
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Bu kısım artık AnimatedBuilder içerisinde ele alındığı için siliyoruz

          // Mobil cihazlarda açılır sidebar - tüm içeriğin üzerinde olması için sonradan ekliyoruz
          if (isMobile)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final slide = 350.0 * _controller.value;
                return Stack(
                  children: [
                    if (_controller.value > 0)
                      GestureDetector(
                        onTap: () {
                          _feedController.toggleSidebar();
                          _controller.reverse();
                        },
                        child: Opacity(
                          opacity: _controller.value * 0.5,
                          child: Container(color: Colors.black),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(-350 + slide, 0),
                      child: SizedBox(
                        width: 350,
                        child: SidebarSocial(profileWidget: ProfileCard()),
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
    _controller.dispose();
    _feedController.dispose();
    super.dispose();
  }
}
