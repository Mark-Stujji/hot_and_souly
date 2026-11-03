import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hot_and_souly/cart.dart';
import 'package:hot_and_souly/models/menu_nav.dart';

// One line inside an info card. If `url` is set, the line is clickable.
class InfoLine {
  final String text;
  final String? url;
  const InfoLine(this.text, [this.url]);
}

// The dark "Find us" section: where we are, when we're open, how to reach us.
class FindUsSection extends StatelessWidget {
  const FindUsSection({super.key});

  static const gold = Color(0xFFE3B341);
  static const dark = Color(0xFF14110F);

  // Your details. Change these and the links update themselves.
  static const address =
      "Kutus, Sagana-Embu Highway, D8 building, Opposite Kutus Leisure Hotel";
  static const phone = "254114278423"; // country code, no + or spaces
  static const email = "hotandsouly26@gmail.com";

  // Opens Google Maps with a search for the address.
  // Tip: for an exact pin, find your shop in Google Maps, press Share,
  // copy the link and paste it here instead.
  static final mapUrl =
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";

  // Opens any link: a web page, a phone call, WhatsApp or email.
  static Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;

    // the three info cards
    final cards = [
      _infoCard(
        Icons.location_on_outlined,
        "VISIT US TODAY",
        [
          const InfoLine("Kutus, Sagana-Embu Highway"),
          const InfoLine("D8 building, Opposite Kutus Leisure Hotel"),
          InfoLine("Get directions on Google Maps  ↗", mapUrl),
        ],
      ),
      _infoCard(
        Icons.access_time,
        "OPEN HOURS",
        [
          const InfoLine("Mon - Fri: 10am - 10pm"),
          const InfoLine("Sat - Sun: 11am - 11pm"),
        ],
      ),
      _infoCard(
        Icons.phone_outlined,
        "CALL OR WHATSAPP",
        [
          InfoLine("Call +254 114 278 423", "tel:+$phone"),
          InfoLine(
            "Chat on WhatsApp  ↗",
            "https://wa.me/$phone?text=${Uri.encodeComponent("Hi Hot & Souly, I'd like to order")}",
          ),
          InfoLine(email, "mailto:$email"),
        ],
      ),
    ];

    return Container(
      key: findUsKey, // marks this section so the nav can scroll here
      width: double.infinity,
      color: dark,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isSmall ? 60 : 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FIND US",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  color: gold,
                ),
              ),
              const SizedBox(height: 16),

              // two-line heading: white upright + gold italic
              Text(
                "Come hungry.",
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: isSmall ? 44 : 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
              Text(
                "Leave happy.",
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: isSmall ? 44 : 60,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: gold,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 40),

              // wide screen: cards side by side. phone: stacked.
              isSmall
                  ? Column(
                children: [
                  for (final card in cards) ...[
                    card,
                    const SizedBox(height: 16),
                  ],
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i < cards.length - 1) const SizedBox(width: 16),
                  ],
                ],
              ),
              const SizedBox(height: 40),

              // two buttons: order and back to the menu
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  FilledButton.icon(
                    onPressed: () => showCartSheet(context),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text("Place your order"),
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: dark,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
                      shape: const StadiumBorder(),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => goToMenu('all'),
                    icon: const Icon(Icons.restaurant_menu, size: 18),
                    label: const Text("See the menu"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // one info card: icon, small title, and lines of text
  // (lines with a url are gold, underlined and clickable)
  Widget _infoCard(IconData icon, String title, List<InfoLine> lines) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A17),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: gold, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: line.url == null
              // plain text line
                  ? Text(
                line.text,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.white,
                ),
              )
              // clickable line
                  : InkWell(
                onTap: () => _open(line.url!),
                child: Text(
                  line.text,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: gold,
                    decoration: TextDecoration.underline,
                    decorationColor: gold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}