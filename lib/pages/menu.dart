import 'package:flutter/material.dart';

import '../cart.dart';

import '../models/item.dart';
import '../models/menu_nav.dart';

// The "The good stuff" section: heading, filter chips and the menu cards.
// It's a StatefulWidget because it must redraw the cards when the
// selected filter changes.
class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  // brand colours used in this section
  static const rust = Color(0xFFB5472F);
  static const gold = Color(0xFFE3B341);
  static const dark = Color(0xFF14110F);

  // Filter chips. Left side = text the customer sees,
  // right side = the category value we compare against item.category.
  final filters = const {
    'All the good stuff': 'all',
    'Fries': 'fries',
    'Tacos': 'tacos',
    'Hot dogs': 'hotdogs',
    'Drinks + sweet': 'drinks',
  };

  // The menu data. It's typed in here for now.
  // Later this list will come from the Node API instead.
  // Prices are in Kenya shillings; ratings are sample values.
  final allItems = const [
    MenuItem(
      id: 1,
      name: 'The Soul Dog',
      tag: 'House favourite',
      description:
      'Grilled dog, caramelised onions, tangy house sauce, crispy shallots.',
      price: 200,
      category: 'hotdogs',
      image: 'lib/images/hot-dog.webp',
      color: Color(0xFFB0452F),
      rating: 4.8,
      reviews: 126,
    ),
    MenuItem(
      id: 2,
      name: 'Loaded Soul Fries',
      tag: 'Crispy corner',
      description:
      'Golden fries, cheese sauce, jalapeño, scallion, smoky drizzle.',
      price: 250,
      category: 'fries',
      image: 'lib/images/fries.webp',
      color: Color(0xFFE0B04A),
      rating: 4.6,
      reviews: 98,
    ),
    MenuItem(
      id: 3,
      name: 'Street Tacos',
      tag: 'Two-bite joy',
      description: 'Soft tortillas, spiced filling, fresh slaw, lime and heat.',
      price: 150,
      category: 'tacos',
      image: 'lib/images/tacos.webp',
      color: Color(0xFF5A6648),
      rating: 4.7,
      reviews: 84,
    ),
    MenuItem(
      id: 4,
      name: 'Sunset Juice',
      tag: 'Fresh pour',
      description: 'Bright, cold-pressed and made for the golden hour.',
      price: 150,
      category: 'drinks',
      image: 'lib/images/juice.webp',
      color: Color(0xFFCF7545),
      rating: 4.5,
      reviews: 61,
    ),
    MenuItem(
      id: 5,
      name: 'Cloud Yoghurt',
      tag: 'Cool down',
      description: 'Silky yoghurt, fruit, crunch and a little honey on top.',
      price: 200,
      category: 'drinks',
      image: 'lib/images/yoghurt.webp',
      color: Color(0xFFE6D3AB),
      rating: 4.4,
      reviews: 47,
    ),
  ];

  // The active filter lives in menuFilter (menu_nav.dart), so both the
  // chips here and the mood strip can change it. This is read-only here.
  String get selected => menuFilter.value;

  @override
  void initState() {
    super.initState();
    // redraw this section whenever the filter changes
    menuFilter.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    menuFilter.removeListener(_onFilterChanged);
    super.dispose();
  }

  void _onFilterChanged() => setState(() {});

  // The list that is actually drawn.
  // It's a getter, so it's recalculated every time the screen rebuilds.
  List<MenuItem> get items => selected == 'all'
      ? allItems
      : allItems.where((i) => i.category == selected).toList();

  // ---------- actions ----------

  // puts a dish in the cart and tells the customer with a small message
  void _addToCart(MenuItem item) {
    cart.add(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} added to your cart'),
          duration: const Duration(milliseconds: 1500),
        ),
      );
  }

  // pop-up with a big picture and full details of one dish
  void _openDetails(MenuItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFFFFFCF7),
          insetPadding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            // scrollable in case the window is short
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // big picture with a close button on top
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          color: item.color,
                          child: item.image == null
                              ? null
                              : Image.asset(
                            item.image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ),
                    ],
                  ),

                  // details under the picture
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tag.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                            color: rust,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ratingRow(item, size: 20),
                        const SizedBox(height: 14),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // price on the left, add button on the right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'KSh ${item.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: rust,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.pop(dialogContext); // close pop-up first
                                _addToCart(item);
                              },
                              icon: const Icon(Icons.add_shopping_cart,
                                  size: 18),
                              label: const Text("Add to cart"),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- star rating ----------

  // Five stars. A rating of 4.5 gives 4 full stars + 1 half star.
  Widget _stars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (rating >= i + 1) {
          icon = Icons.star; // full
        } else if (rating >= i + 0.5) {
          icon = Icons.star_half; // half
        } else {
          icon = Icons.star_border; // empty
        }
        return Icon(icon, size: size, color: gold);
      }),
    );
  }

  // stars + "4.8 (126)" text
  Widget _ratingRow(MenuItem item, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stars(item.rating, size: size),
        const SizedBox(width: 8),
        Text(
          '${item.rating} (${item.reviews})',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  // ---------- page layout ----------

  @override
  Widget build(BuildContext context) {
    return Container(
      key: menuKey, // marks this section so the page can scroll to it
      width: double.infinity,
      color: const Color(0xFFEDE4D8), // warm beige section background
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        // keeps the content from stretching too wide on big monitors
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // small red label above the heading
              const Text(
                "MADE TO HIT THE SPOT",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  color: rust,
                ),
              ),
              const SizedBox(height: 16),

              // two-line heading: dark upright + gold italic
              const Text(
                "The good",
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: dark,
                  height: 1.05,
                ),
              ),
              const Text(
                "stuff",
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: gold,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Five ways to make your day\ntaste a little better.",
                style:
                TextStyle(fontSize: 15, height: 1.6, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              _chips(), // filter buttons
              const SizedBox(height: 28),
              _grid(), // the menu cards
            ],
          ),
        ),
      ),
    );
  }

  // ---------- filter chips ----------
  // One rounded button per entry in `filters`.
  // Tapping one changes menuFilter, which redraws the section.
  Widget _chips() {
    return Wrap(
      // Wrap moves chips to a new line when there isn't enough width
      spacing: 10,
      runSpacing: 10,
      children: filters.entries.map((f) {
        final active = selected == f.value; // is this the chosen chip?

        return InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => menuFilter.value = f.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              // chosen chip is filled dark, the others are just outlined
              color: active ? dark : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: active ? dark : Colors.black26),
            ),
            child: Text(
              f.key,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------- card grid ----------
  // Works out how wide each card should be, then lays them out in a Wrap.
  Widget _grid() {
    return LayoutBuilder(
      // LayoutBuilder tells us how much width this section really has
      builder: (context, c) {
        const gap = 16.0;
        final isWide = c.maxWidth >= 900;

        // 3 cards per row on wide screens, 2 on phones/tablets
        final cols = isWide ? 3 : 2;

        // width of one card = (total width - the gaps between cards) / columns
        final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < items.length; i++)
              SizedBox(
                // when showing everything, the first card spans the full row
                width: (i == 0 && selected == 'all') ? c.maxWidth : cardWidth,
                child: _card(
                  items[i],
                  featured: i == 0 && selected == 'all',
                  isWide: isWide,
                ),
              ),
          ],
        );
      },
    );
  }

  // ---------- one menu card ----------
  // item     = the dish to show
  // featured = true for the big first card
  // isWide   = true on desktop-size screens (changes the picture shape)
  Widget _card(MenuItem item, {required bool featured, required bool isWide}) {
    // Material + InkWell = the whole card is clickable (opens the pop-up)
    return Material(
      color: const Color(0xFFFFFCF7), // off-white card body
      child: InkWell(
        onTap: () => _openDetails(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top part: the picture, sized by SHAPE (aspect ratio = width / height)
            // instead of a fixed height, so photos don't get squeezed.
            AspectRatio(
              aspectRatio: featured ? (isWide ? 2.4 : 1.5) : 1.1,
              child: Container(
                color: item.color, // shows while loading or if photo is missing
                child: item.image == null
                    ? const SizedBox.shrink()
                    : Image.asset(
                  item.image!,
                  fit: BoxFit.cover, // fill the area, crop the extra
                  width: double.infinity,
                  height: double.infinity,
                  // wrong file name? show an icon instead of a red error
                  errorBuilder: (context, error, stack) => const Center(
                    child: Icon(Icons.fastfood,
                        size: 48, color: Colors.white54),
                  ),
                ),
              ),
            ),

            // Bottom part: tag, name, description, price, rating, button.
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // small red tag, e.g. "HOUSE FAVOURITE"
                  Text(
                    item.tag.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: rust,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // name + description on the left, price on the right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expanded gives the text all the space the price doesn't use
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: dark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // price in Kenya shillings, no decimals: 450 -> KSh 450
                      Text(
                        'KSh ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: rust,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // stars on the left, add button on the right.
                  // Wrap lets the button drop to the next line on narrow cards.
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      _ratingRow(item),
                      FilledButton.icon(
                        onPressed: () => _addToCart(item),
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text("Add"),
                        style: FilledButton.styleFrom(
                          backgroundColor: dark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}