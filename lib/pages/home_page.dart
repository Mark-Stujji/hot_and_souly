import 'dart:async';

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
    final isSmall = size.width < 700;

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
              child: SizedBox(
                width: double.infinity,
                // photo + tint. On phones the photo drifts and can be swiped.
                child: HeroBackground(
                  pan: isSmall,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 20 : 24,
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
                                _navBar(context, isSmall),
                                // gap under the nav bar. Bigger on phones so
                                // the text sits nearer the middle of the screen.
                                SizedBox(
                                  height: isSmall
                                      ? (size.height * 0.13)
                                      .clamp(48.0, 130.0)
                                      .toDouble()
                                      : (size.height * 0.08)
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

  // top bar: logo + name on the left, links (or a ☰ menu on phones) on the right
  Widget _navBar(BuildContext context, bool isSmall) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            "lib/images/HSlogo.webp",
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

        if (isSmall)
        // phones: one ☰ button with all the links inside
          _mobileMenu(context)
        else ...[
          // laptops: links in a row, each scrolls to its section
          _navLink("Menu", () => goToMenu('all')),
          _navLink("Our vibe", () => scrollToSection(storyKey)),
          _navLink("Find us", () => scrollToSection(findUsKey)),
          const SizedBox(width: 40),

          // order button: opens the cart
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
      ],
    );
  }

  // ☰ dropdown for phones
  Widget _mobileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
      color: const Color(0xFF1E1A17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'menu':
            goToMenu('all');
            break;
          case 'vibe':
            scrollToSection(storyKey);
            break;
          case 'find':
            scrollToSection(findUsKey);
            break;
          case 'order':
            showCartSheet(context);
            break;
        }
      },
      itemBuilder: (context) => [
        _menuItem('menu', 'Menu', Icons.restaurant_menu),
        _menuItem('vibe', 'Our vibe', Icons.favorite_border),
        _menuItem('find', 'Find us', Icons.place_outlined),
        _menuItem('order', 'Order Now', Icons.shopping_bag_outlined,
            highlight: true),
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String value, String text, IconData icon,
      {bool highlight = false}) {
    final color = highlight ? const Color(0xFFE3B341) : Colors.white;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
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

// Hero photo + dark tint behind the hero content.
// Phones (pan = true): the photo slowly drifts across the food with a gentle
// zoom, and the visitor can swipe left/right to explore it. After a swipe it
// waits 3 seconds, then carries on drifting.
// Laptops (pan = false): a still, centred photo with an even tint, as before.
class HeroBackground extends StatefulWidget {
  const HeroBackground({super.key, required this.pan, required this.child});

  final bool pan;
  final Widget child;

  @override
  State<HeroBackground> createState() => _HeroBackgroundState();
}

class _HeroBackgroundState extends State<HeroBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );
  Timer? _resume;

  @override
  void initState() {
    super.initState();
    _ctrl.value = 0.5; // start on the fries and hot dog
    if (widget.pan) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(HeroBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // window resized between phone and laptop width
    if (widget.pan != oldWidget.pan) {
      if (widget.pan) {
        _ctrl.repeat(reverse: true);
      } else {
        _resume?.cancel();
        _ctrl.stop();
        _ctrl.value = 0.5;
      }
    }
  }

  @override
  void dispose() {
    _resume?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _dragStart(DragStartDetails d) {
    _resume?.cancel();
    _ctrl.stop();
  }

  void _dragUpdate(DragUpdateDetails d) {
    // finger moves left -> photo moves left with it (shows more of the right)
    final w = context.size?.width ?? 400;
    _ctrl.value = (_ctrl.value - (d.primaryDelta ?? 0) / w).clamp(0.0, 1.0);
  }

  void _dragEnd(DragEndDetails d) {
    _resume = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.pan) _ctrl.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final photo = AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = widget.pan ? Curves.easeInOut.transform(_ctrl.value) : 0.5;
        // left edge of the photo is mostly empty table, so start at -0.3
        final x = widget.pan ? -0.3 + 1.3 * t : 0.0;
        return Transform.scale(
          scale: widget.pan ? 1.04 + 0.05 * t : 1.0,
          child: Image.asset(
            "lib/images/background.webp",
            fit: BoxFit.cover,
            alignment: Alignment(x, 0),
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
          ),
        );
      },
    );

    final tint = DecoratedBox(
      decoration: BoxDecoration(
        gradient: widget.pan
            ? const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xD9000000),
            Color(0x8C000000),
            Color(0xB3000000),
          ],
          stops: [0.0, 0.45, 1.0],
        )
            : const LinearGradient(
          colors: [Color(0x66000000), Color(0x66000000)],
        ),
      ),
    );

    final layers = Stack(
      children: [
        Positioned.fill(child: ClipRect(child: photo)),
        Positioned.fill(child: IgnorePointer(child: tint)),
        widget.child,
      ],
    );

    if (!widget.pan) return layers;

    // horizontal swipes pan the photo; taps and vertical scrolling still work
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: _dragStart,
      onHorizontalDragUpdate: _dragUpdate,
      onHorizontalDragEnd: _dragEnd,
      child: layers,
    );
  }
}