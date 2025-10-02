export 'package:flutter/material.dart';
export 'views/layouts/layout.dart';
export 'views/components/components.dart  ';
import 'package:flutter/material.dart';
import 'views/layouts/layout.dart';

export 'package:provider/provider.dart';
export 'package:google_fonts/google_fonts.dart';
class AppRoutes {
  // Named routes tanımı
  static Map<String, WidgetBuilder> getroutes() {
    return {
      '/': (context) => const HomeView(),
      // Diğer sabit rotaları burada tanımlayabilirsiniz
    };
  }
  
  // Dinamik rotalar için generateRoute
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final path = settings.name ?? '';
    
    debugPrint('⚡ Route çağrıldı: $path'); // Debug için rota bilgisi
    
    // /feed_detail/{sef} patternini yakalama
    final feedDetailRegex = RegExp(r'^\/feed_detail\/(.+)$');
    if (feedDetailRegex.hasMatch(path)) {
      final match = feedDetailRegex.firstMatch(path);
      final sef = match?.group(1) ?? '';
      debugPrint('📋 Feed Detail: $sef'); // Debug için sef değeri
      
      // Eğer sef değeri boşsa ana sayfaya yönlendir
      if (sef.isEmpty) {
        debugPrint('❌ Boş sef değeri, ana sayfaya yönlendiriliyor');
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
          settings: settings,
        );
      }
      
      return MaterialPageRoute(
        builder: (context) => FeedView(sef: sef),
        settings: settings,
      );
    }
    
    // fallback: bilinmeyen route
    debugPrint('⚠️ Bilinmeyen route: $path'); // Debug için hata bilgisi
    return MaterialPageRoute(
      builder: (_) => const HomeView(),
      settings: settings,
    );
  }
}
