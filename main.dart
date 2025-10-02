
import 'package:flutter_design/service/user_service.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final userService = UserService();

  // App başlatılırken
  userService.initActiveUser();

  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialCode',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue, // X’in mavi aksan rengi
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1DA1F2), // Twitter/X mavi rengi
        scaffoldBackgroundColor: const Color(0xFF0F1419), // X dark arka plan
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1419),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        cardColor: const Color(0xFF15202B), // Kart arka planları
        dividerColor: const Color.fromARGB(31, 255, 0, 0),
      ),
      themeMode: ThemeMode.dark, // Dark mode aktif
      initialRoute: '/', // Başlangıç rotası
      routes: AppRoutes.getroutes(),
      onGenerateRoute: AppRoutes.generateRoute,

      navigatorObservers: [
        // Route değişikliklerini izlemek için observer ekleyin
        RouteObserver<PageRoute>(),
      ],
    );
  }
}
