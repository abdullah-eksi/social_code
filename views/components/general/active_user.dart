import 'package:flutter/material.dart';
import '/models/user_model.dart';
import '/service/user_service.dart';

class ActiveUsersWidget extends StatefulWidget {
  final Function(String)? onTap;

  const ActiveUsersWidget({super.key, this.onTap});

  @override
  State<ActiveUsersWidget> createState() => _ActiveUsersWidgetState();
}

class _ActiveUsersWidgetState extends State<ActiveUsersWidget> {
  late Future<List<UserModel>> _usersFuture;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _usersFuture = userService.getUsers();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "online":
        return Colors.green;
      case "away":
        return Colors.orange;
      case "busy":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Son Aktif Kullanıcılar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<UserModel>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                      "Kullanıcılar yüklenemedi",
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Kullanıcı bulunamadı");
                  } else {
                    final users = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        // Web için CORS problemi olursa, asset avatar kullanabilirsin:
                        // String avatar = 'assets/avatars/avatar${index+1}.png';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Material(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withAlpha(26), // 0.1 -> withAlpha(0.1*255=26)
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                if (widget.onTap != null) widget.onTap!(user.name);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      backgroundImage: user.avatarUrl.isNotEmpty
                                          ? NetworkImage(user.avatarUrl) // NetworkImage kullan
                                          : null,
                                      child: user.avatarUrl.isEmpty
                                          ? Text(
                                              user.name[0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  user.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  user.username,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            user.description,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: getStatusColor(user.status),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
