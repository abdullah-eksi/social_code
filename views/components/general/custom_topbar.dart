import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? left;   // Soldaki widget (profil ikon)
  final Widget? center; // Ortadaki widget (logo)
  final List<Widget>? right; // Sağdaki birden fazla action olabilir
  final Color bgColor;
  final double elevation;

  const CustomTopBar({
    super.key,
    this.left,
    this.center,
    this.right,
    this.bgColor = Colors.white,
    this.elevation = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation,
      leading: left, // sola
      title: center, // ortada
      centerTitle: true,
      actions: right, // sağa
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
