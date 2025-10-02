
import '/routes.dart';


import '/controllers/home/home_controller.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final HomeController _homeController = HomeController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _homeController.addListener(() {
      if (mounted) setState(() {}); // sadece kategori değişirse rebuild
    });
  }

  void _refreshContent() {
    _homeController.refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1500;

    return Scaffold(
      appBar: CustomTopBar(
        bgColor: Colors.black,
        elevation: 0,
        center: Text("SocialCode", style: GoogleFonts.pacifico(fontSize: 28)),
        left: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _homeController.toggleSidebar();
                  if (_homeController.isSidebarOpen) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
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
                  child: SidebarSocial(profileWidget: ProfileCard()),
                ),

              // Orta içerik
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26), // 0.1 -> withAlpha(0.1*255=26)
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SliderMenu(
                          items: [
                            "Anasayfa",
                            "Sana Özel",
                            "Popüler",
                            "Yazılım",
                            "Mobil",
                            "Web",
                            "Siber Güvenlik",
                            "Php",
                            "Java",
                            "Python",
                            "Flutter",
                            "Dart",
                            "JavaScript",
                            "C#",
                            "C++",
                            "Ruby",
                            "Swift",
                            "Kotlin",
                            "Go",
                            "Rust",
                            "TypeScript",
                            "HTML",
                            "CSS",
                          ],
                          onTap: (index) {
                            _homeController.selectCategory(index);
                            debugPrint("Kategori seçildi: $index");
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Feed burada artık rebuild olmaz sidebar toggle sırasında
                      Expanded(
                        child: FeedListWidget(
                          selectedCategoryIndex:
                              _homeController.selectedCategoryIndex,
                          key: ValueKey(
                              'feed-list-${_homeController.selectedCategoryIndex}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sağ panel masaüstünde
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
                          LastSubjectsWidget(
                            refreshTrigger: _homeController.refreshTrigger,
                            onRefresh: _refreshContent,
                          ),
                          const SizedBox(height: 12),
                          ActiveUsersWidget(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Mobil overlay sidebar
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
                          _homeController.toggleSidebar();
                          _controller.reverse();
                        },
                        child: Opacity(
                          opacity: _controller.value * 0.5,
                          child: Container(
                            color: Colors.black,
                          ),
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
    _homeController.dispose();
    super.dispose();
  }
}
