import 'package:flutter/material.dart';
import '/service/user_service.dart';
import '/models/user_model.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final UserService _userService = UserService();
  UserModel? _activeUser;

  @override
  void initState() {
    super.initState();
    _loadActiveUser();
  }

  Future<void> _loadActiveUser() async {
    await _userService.initActiveUser(); // aktif kullanıcıyı seç (id=1)
    setState(() {
      _activeUser = _userService.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_activeUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Sidebar açma ya da profil sayfasına gitme
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${_activeUser!.name} profiline gidiliyor...")),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_activeUser!.avatarUrl),
                radius: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeUser!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      _activeUser!.username,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
