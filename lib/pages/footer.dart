import 'package:flutter/material.dart';

import '../models/menu_nav.dart';

// The very bottom of the page: logo, quick links and copyright.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;

    // brand block on the left
    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            "lib/images/HSlogo.webp",
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hot & Souly",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "SOULFUL FLAVOURS",
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );

    // quick links, each scrolls to its section
    final links = Wrap(
      spacing: 28,
      runSpacing: 10,
      children: [
        _link("Menu", () => goToMenu('all')),
        _link("Our vibe", () => scrollToSection(storyKey)),
        _link("Find us", () => scrollToSection(findUsKey)),
      ],
    );

    return Container(
      width: double.infinity,
      color: const Color(0xFF0D0B0A),
      // extra space at the bottom (100) so the floating cart button
      // doesn't sit on top of the links when you reach the end of the page
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // phone: stacked. wide: brand left, links right
              isSmall
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [brand, const SizedBox(height: 24), links],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [brand, links],
              ),
              const SizedBox(height: 32),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "© 2026 Hot & Souly. All rights reserved.",
                  style: TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // one footer link: text + what happens on click
  Widget _link(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }
}