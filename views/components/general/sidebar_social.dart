import 'package:flutter/material.dart';
import '/service/sidebar_item.dart';
import '/models/sidebar_model.dart';

class SidebarSocial extends StatelessWidget {
  final Widget profileWidget;

  const SidebarSocial({
    super.key,
    required this.profileWidget,
  });

  @override
  Widget build(BuildContext context) {
    final List<SidebarItem> menuItems = SidebarService().getItems();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
         color: const Color.fromARGB(122, 0, 0, 0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
     
      child: Column(
        children: [
          // Menü öğelerini ortalamak için üst spacer
          const Spacer(),

          // Menü items
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems.map((item) {
              return InkWell(
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(item.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Menü ile profil arasında boşluk
          const Spacer(),

          // Profil widget en altta
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: profileWidget,
          ),
        ],
      ),
    );
  }
}
