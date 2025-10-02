import '../models/user_model.dart';

class UserService {
  UserModel? _currentUser; // aktif kullanıcı

  // Dummy kullanıcı listesi
  Future<List<UserModel>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500)); // fake network delay

    return [
      UserModel(
        userId: "1",
        name: "Abdullah Ekşi",
        username: "@abdullah",
        email: "abdullah@example.com",
        status: "online",
        description: "Backend Developer | PHP & Flutter sever",
        avatarUrl: "https://mockmind-api.uifaces.co/content/human/61.jpg",
        password: "123456",
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        userId: "2",
        name: "Elif Yılmaz",
        username: "@elif_dev",
        email: "elif@example.com",
        status: "away",
        description: "Frontend Developer | React & UI/UX tutkunu",
        avatarUrl: "https://mockmind-api.uifaces.co/content/human/82.jpg",
        password: "abcdef",
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        userId: "3",
        name: "Mehmet Kaya",
        username: "@mehmetk",
        email: "mehmet@example.com",
        status: "busy",
        description: "Full Stack Developer | Java & Spring Boot 🔥",
        avatarUrl: "https://mockmind-api.uifaces.co/content/human/60.jpg",
        password: "qwerty",
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        userId: "4",
        name: "Zeynep Demir",
        username: "@zeynepcodes",
        email: "zeynep@example.com",
        status: "online",
        description: "Mobile Developer | Flutter ❤️",
        avatarUrl: "https://mockmind-api.uifaces.co/content/human/84.jpg",
        password: "pass123",
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // ID ile kullanıcı bul
  Future<UserModel?> getUserById(String userId) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Username ile kullanıcı bul
  Future<UserModel?> getUserByUsername(String username) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  // Durum güncelleme (dummy)
  Future<void> updateStatus(String userId, String newStatus) async {
    // Gerçek bir uygulama durumu güncelleyecektir
  }

  // Basit login denemesi (dummy)
  Future<UserModel?> login(String username, String password) async {
    final user = await getUserByUsername(username);
    if (user == null) return null; // kullanıcı yok
    if (user.password == password) {
      _currentUser = user; // aktif kullanıcı olarak ata
      return user;
    }
    return null;
  }

  Future<void> initActiveUser() async {
    final users = await getUsers();
    try {
      _currentUser = users.firstWhere((user) => user.userId == "1");
    } catch (e) {
      // Kullanıcı bulunamazsa _currentUser null kalır
      _currentUser = null;
    }
  }
  
  // Aktif kullanıcıyı döndür
  UserModel? get currentUser => _currentUser;

  // Logout (dummy)
  void logout() {
    _currentUser = null;
  }
}