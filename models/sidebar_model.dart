import 'package:flutter/material.dart';

class SidebarItem {
  final String title;          // Menü başlığı
  final IconData icon;         // Menü ikonu
  final VoidCallback onTap;    // Tıklama callback
  final String? subtitle;      // Opsiyonel alt yazı
  final int? badgeCount;       // Opsiyonel badge (ör: mesaj sayısı)
  final Color? iconColor;      // İkon rengi
  final Color? textColor;      // Yazı rengi
   bool isSelected;       // Aktif öğe vurgusu
  final double iconSize;       // İkon boyutu

  SidebarItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.badgeCount,
    this.iconColor,
    this.textColor,
    this.isSelected = false,
    this.iconSize = 24,
  });
}
