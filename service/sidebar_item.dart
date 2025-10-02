import 'package:flutter/material.dart';
import '/models/sidebar_model.dart';

class SidebarService {
  // Menü itemları saklayacak liste
final List<SidebarItem> _items = [
  SidebarItem(
    title: "Ana Sayfa",
    icon: Icons.home,
    onTap: () {},
    isSelected: true,
  ),
  SidebarItem(
    title: "Keşfet",
    icon: Icons.search,
    onTap: () {},
  ),
  SidebarItem(
    title: "Bildirimler",
    icon: Icons.notifications,
    onTap: () {},
    badgeCount: 3,
  ),

  SidebarItem(
    title: "Kaydedilenler",
    icon: Icons.bookmark,
    onTap: () {},
  ),
 
  SidebarItem(
    title: "Profil",
    icon: Icons.person,
    onTap: () {},
  ),
  SidebarItem(
    title: "Ayarlar",
    icon: Icons.more_horiz,
    onTap: () {},
  ),
];


  // Tüm menüyü getir
  List<SidebarItem> getItems() => _items;

  // Yeni item ekle
  void addItem(SidebarItem item) {
    _items.add(item);
  }

  // Item güncelle (başlığa göre)
  void updateItem(String title, SidebarItem newItem) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index != -1) _items[index] = newItem;
  }

  // Item sil (başlığa göre)
  void removeItem(String title) {
    _items.removeWhere((item) => item.title == title);
  }

  // Aktif itemi seç
  void selectItem(String title) {
    for (var item in _items) {
      item.isSelected = item.title == title;
    }
  }
}
