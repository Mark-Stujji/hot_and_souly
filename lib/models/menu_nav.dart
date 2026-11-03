import 'package:flutter/material.dart';

// Shared by the nav bar, mood strip, hero buttons and the page sections.

// Name tags that mark where each section sits on the page,
// so we can scroll to them from anywhere.
final menuKey = GlobalKey(); // "The good stuff" menu
final storyKey = GlobalKey(); // "Our vibe" story section
final findUsKey = GlobalKey(); // "Find us" section

final menuFilter = ValueNotifier<String>('all');

// Smoothly scrolls the page until the marked section is on screen.
void scrollToSection(GlobalKey key) {
  final target = key.currentContext;
  if (target != null) {
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}

// Picks a menu filter, then scrolls the page down to the menu.
void goToMenu(String category) {
  menuFilter.value = category;
  scrollToSection(menuKey);
}