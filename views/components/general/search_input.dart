import 'package:flutter/material.dart';

Widget cSearchInput({
  required BuildContext context,
  required TextEditingController controller,
  required Function(String) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.all( 8.0),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Arama yapın...',
        prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
    ),
  );
}