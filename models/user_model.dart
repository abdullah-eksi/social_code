class UserModel {
  final String userId;
  final String name;
  final String username;
  final String email;
  final String status; // online, away, busy, offline
  final String description;
  final String avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  // Sosyal etkileşim
  final int followersCount;
  final int followingCount;
  final int postCount;

  // Roller ve izinler
  final List<String> roles;
  final bool isBanned;

  // Ek bilgiler
  final List<String> interests;
  final List<String> badges;
  final DateTime? lastSeen;

  UserModel({
    required this.userId,
    required this.name,
    required this.username,
    this.email = '',
    required this.status,
    required this.description,
    this.avatarUrl = '',
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
    this.roles = const ['user'],
    this.isBanned = false,
    this.interests = const [],
    this.badges = const [],
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'offline',
      description: json['description'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postCount: json['postCount'] ?? 0,
      roles: List<String>.from(json['roles'] ?? ['user']),
      isBanned: json['isBanned'] ?? false,
      interests: List<String>.from(json['interests'] ?? []),
      badges: List<String>.from(json['badges'] ?? []),
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'])
          : null,
      password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'username': username,
      'email': email,
      'status': status,
      'description': description,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postCount': postCount,
      'roles': roles,
      'isBanned': isBanned,
      'interests': interests,
      'badges': badges,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  // Admin kontrolü
  bool get isAdmin => roles.contains('admin');
}
