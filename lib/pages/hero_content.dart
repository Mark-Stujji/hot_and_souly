import 'package:flutter/material.dart';
import 'package:hot_and_souly/cart.dart';
import 'package:hot_and_souly/models/menu_nav.dart';

// The text part of the hero: tagline, headline, paragraph and buttons.
// It has no fixed height, so the hero grows to fit it.
class HeroContent extends StatelessWidget {
  const HeroContent({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 700;

    // Headline size. Phones: based on width so it fills the line nicely.
    // Laptops: same formula as before (shrinks on narrow AND short windows).
    final headlineSize = isSmall
        ? (size.width * 0.135).clamp(40.0, 58.0).toDouble()
        : (size.width * 0.12)
        .clamp(40.0, (size.height * 0.11).clamp(48.0, 84.0).toDouble())
        .toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // gold dot + small tagline
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFE3B341),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            // Flexible: the tagline wraps instead of overflowing
            Flexible(
              child: Text(
                "FRESH OFF THE GRILL · ALWAYS SOULFUL",
                style: TextStyle(
                  fontSize: isSmall ? 10.5 : 12,
                  letterSpacing: isSmall ? 1.2 : 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isSmall ? 16 : 20),

        // headline line 1: white, upright
        Text(
          "Hot food.",
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.05,
          ),
        ),

        // headline line 2: gold, italic
        Text(
          "Good mood.",
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: const Color(0xFFE3B341),
            height: 1.05,
          ),
        ),
        SizedBox(height: isSmall ? 18 : 24),

        // paragraph, max width so it wraps nicely
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            "Big flavour, crispy edges, and a little bit of soul in every bite. "
                "Your neighbourhood stop for fries, tacos, hot dogs, and the good "
                "stuff on the side.",
            style: TextStyle(
              fontSize: isSmall ? 15.5 : 20,
              height: isSmall ? 1.55 : 1.6,
              color: isSmall ? Colors.white : Colors.white70,
            ),
          ),
        ),
        SizedBox(height: isSmall ? 26 : 32),

        // Phones: two compact pills side by side, brand label underneath.
        // Laptops: full-size buttons with the brand label on the far right.
        if (isSmall) ...[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Row(
              children: [
                Expanded(child: _menuButton(compact: true)),
                const SizedBox(width: 10),
                Expanded(child: _orderButton(context, compact: true)),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _BrandLabel(),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _menuButton(),
                    _orderButton(context),
                  ],
                ),
              ),
              if (size.width >= 900) const _BrandLabel(),
            ],
          ),
      ],
    );
  }

  // filled gold button: scrolls down to the full menu
  Widget _menuButton({bool compact = false}) {
    return ElevatedButton.icon(
      onPressed: () => goToMenu('all'),
      icon: Icon(Icons.arrow_downward, size: compact ? 15 : 16),
      label: Text(compact ? "See menu" : "See the menu"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3B341),
        foregroundColor: const Color(0xFF14110F),
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 14)
            : const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: compact ? 13.5 : 15,
        ),
      ),
    );
  }

  // outlined button: opens the cart / order sheet
  Widget _orderButton(BuildContext context, {bool compact = false}) {
    return OutlinedButton.icon(
      onPressed: () => showCartSheet(context),
      icon: Icon(Icons.north_east, size: compact ? 15 : 16),
      label: Text(compact ? "Order now" : "Place your order"),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0x33000000),
        side: const BorderSide(color: Colors.white54),
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 14)
            : const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: compact ? 13.5 : 15,
        ),
      ),
    );
  }
}

// The brand label: "H & S / FAST FOOD / WITH A PULSE" on a dark rounded panel,
// so it stays readable on top of the busy photo.
class _BrandLabel extends StatelessWidget {
  const _BrandLabel();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xB3000000), // black at about 70%
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "H & S",
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE3B341),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FAST FOOD",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "WITH A PULSE",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// The thin strip pinned to the bottom of the hero.
// On phones it also hints that the photo can be swiped.
class HeroBottomStrip extends StatelessWidget {
  const HeroBottomStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;

    return Row(
      children: [
        Container(width: 30, height: 1, color: const Color(0xFFE3B341)),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            isSmall
                ? "SWIPE THE PHOTO · SCROLL TO EXPLORE"
                : "SCROLL TO EXPLORE",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}