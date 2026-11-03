import 'package:flutter/material.dart';

import '../models/menu_nav.dart';


// The cream "Pick your mood" bar under the hero.
// Clicking an item scrolls down to the menu and shows that category.
class MoodStrip extends StatelessWidget {
  const MoodStrip({super.key});

  // [icon, label shown, category to open in the menu]
  static const moods = [
    ['🍟', 'Fries', 'fries'],
    ['🌮', 'Tacos', 'tacos'],
    ['🌭', 'Hot dogs', 'hotdogs'],
    ['🧃', 'Juice', 'drinks'],
    ['🥣', 'Yoghurt', 'drinks'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEFE6DA),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Wrap(
        spacing: 40,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            "PICK YOUR MOOD",
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB5472F),
            ),
          ),

          // one clickable item per mood
          for (final mood in moods)
            InkWell(
              // mood[2] is the category: fries, tacos, hotdogs or drinks
              onTap: () => goToMenu(mood[2]),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mood[0], style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      mood[1],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF14110F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}