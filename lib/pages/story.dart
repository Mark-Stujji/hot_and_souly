import 'package:flutter/material.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  // colours used in this section
  static const gold = Color(0xFFE3B341);
  static const rust = Color(0xFFB5472F);
  static const dark = Color(0xFF14110F);

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF4EEE6),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isSmall ? 60 : 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          // phone: image on top, text below. wide screen: side by side
          child: isSmall
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _photo(),
              const SizedBox(height: 50),
              _text(isSmall),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _photo()),
              const SizedBox(width: 80),
              Expanded(child: _text(isSmall)),
            ],
          ),
        ),
      ),
    );
  }

  // photo with the offset frame and the round badge
  Widget _photo() {
    return Padding(
      // room for the frame that sticks out bottom-right
      padding: const EdgeInsets.only(right: 24, bottom: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: AspectRatio(
          aspectRatio: 0.92,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // thin rust frame, shifted down and right
              Positioned(
                left: 24,
                top: 24,
                right: -24,
                bottom: -24,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: rust, width: 1),
                  ),
                ),
              ),

              // the photo itself with a soft shadow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Image.asset("lib/images/use.png", fit: BoxFit.cover),
                ),
              ),

              // gold badge on the top-right corner
              Positioned(
                top: -22,
                right: -22,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: rust, width: 1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "H&S",
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: dark,
                        ),
                      ),
                      Text(
                        "MADE WITH\nFEELING",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 7,
                          letterSpacing: 1,
                          color: dark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // right side: label, headline, paragraph, link, signature line
  Widget _text(bool isSmall) {
    final headlineSize = isSmall ? 44.0 : 60.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "NOT JUST FAST FOOD",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            color: rust,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          "A little",
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            color: dark,
            height: 1.05,
          ),
        ),
        Text(
          "more feeling",
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: gold,
            height: 1.05,
          ),
        ),
        Text(
          "in every bite.",
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            color: dark,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 28),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const Text(
            "Hot & Souly is for the hungry ones, the late-night ones, the "
                "“let’s get one more” ones. We keep the menu familiar, then turn "
                "up the flavour with fresh toppings, house sauces, and a whole "
                "lot of heart.",
            style: TextStyle(fontSize: 16, height: 1.7, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 28),

        // underlined link
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: dark, width: 1)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Meet the menu",
                  style: TextStyle(fontWeight: FontWeight.bold, color: dark),
                ),
                SizedBox(width: 8),
                Icon(Icons.north_east, size: 12, color: dark),
              ],
            ),
          ),
        ),
        const SizedBox(height: 36),

        // small signature line
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Soulful flavours",
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(width: 12),
            SizedBox(width: 20, child: Divider(color: gold, thickness: 1)),
            SizedBox(width: 12),
            Text(
              "since day one",
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}