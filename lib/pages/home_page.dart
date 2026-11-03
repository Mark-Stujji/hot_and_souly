import 'package:flutter/material.dart';
import 'package:hot_and_souly/models/menu_nav.dart';
import 'package:hot_and_souly/pages/footer.dart';
import 'package:hot_and_souly/pages/hero_content.dart';
import 'package:hot_and_souly/pages/menu.dart';
import 'package:hot_and_souly/pages/mood.dart';
import 'package:hot_and_souly/pages/story.dart';

import '../cart.dart';
import 'findus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      // round cart button in the corner, shows how many items are in the cart
      floatingActionButton: ListenableBuilder(
        listenable: cart,
        builder: (context, _) => FloatingActionButton.extended(
          onPressed: () => showCartSheet(context),
          backgroundColor: const Color(0xFFE3B341),
          foregroundColor: const Color(0xFF14110F),
          icon: const Icon(Icons.shopping_bag_outlined),
          label: Text('Cart (${cart.count})'),
        ),
      ),
      // whole page scrolls so the sections below the hero can be reached
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero: at least one screen tall. Its content flows top to bottom
            // and makes it taller if needed, so nothing can overflow.
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Container(
                width: double.infinity,
                // background photo with a dark tint so the text is readable
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/images/background.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color(0x66000000),
                      BlendMode.srcOver,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Stack(
                      children: [
                        // main content, flows naturally and sets the height
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // context is passed in so "Order Now" opens the cart
                              _navBar(context, width < 700),
                              // gap under the nav bar, scales with the window
                              SizedBox(
                                height: (size.height * 0.08)
                                    .clamp(24.0, 90.0)
                                    .toDouble(),
                              ),
                              const HeroContent(),
                              // space reserved for the strip pinned below
                              const SizedBox(height: 110),
                            ],
                          ),
                        ),

                        // strip pinned to the bottom of the hero
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: HeroBottomStrip(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // the sections, top to bottom
            const MoodStrip(),
            const StorySection(), // "Our vibe"
            const MenuSection(),
            const FindUsSection(),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // top bar: logo + name on the left, links on the right
  Widget _navBar(BuildContext context, bool isSmall) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            "lib/images/HSlogo.png",
            height: isSmall ? 48 : 80, // smaller logo on phones
            width: isSmall ? 48 : 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),

        // Expanded takes ALL the free width, which pushes the links to the
        // right edge. The name still shrinks (ellipsis) instead of overflowing.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hot & Souly",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmall ? 20 : 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "SOULFUL FLAVOURS",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmall ? 9 : 12,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),

        // links only show on wide screens; each scrolls to its section
        if (!isSmall) ...[
          _navLink("Menu", () => goToMenu('all')),
          _navLink("Our vibe", () => scrollToSection(storyKey)),
          _navLink("Find us", () => scrollToSection(findUsKey)),
          const SizedBox(width: 40),
        ],

        // order button, always visible: opens the cart
        InkWell(
          onTap: () => showCartSheet(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Order Now",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.north_east, size: 14, color: Color(0xFFE3B341)),
            ],
          ),
        ),
      ],
    );
  }

  // one nav link: text + what happens on click, size can be changed per link
  Widget _navLink(String text, VoidCallback onTap, {double size = 14}) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}