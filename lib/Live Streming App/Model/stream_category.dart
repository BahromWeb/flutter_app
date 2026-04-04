import 'package:flutter/material.dart';

class StreamCategory {
  final String title;
  final IconData icon;

  StreamCategory({required this.title, required this.icon});
}

final streamCategory = [
  StreamCategory(title: 'Popular', icon: Icons.local_fire_department_outlined),
  StreamCategory(title: 'Gaming', icon: Icons.sports_esports_outlined),
  StreamCategory(title: 'Sports', icon: Icons.sports_soccer_outlined),
  StreamCategory(title: 'Music', icon: Icons.music_note_outlined),
];
