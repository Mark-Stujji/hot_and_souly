import 'package:flutter/material.dart';

// one menu item
class MenuItem {
  final int id;
  final String name;
  final String tag;
  final String description;
  final double price;
  final String category;

  final String? image;
  final Color color;
  final double rating;
  final int reviews;

  const MenuItem({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.price,
    required this.category,
    this.image,
    required this.color,
    this.rating = 4.5,
    this.reviews = 0,
  });

  // Builds a MenuItem from the JSON the Node API sends.
  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'] as int,
    name: json['name'] as String,
    tag: json['tag'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String,
    image: json['image'] as String?,
    // the API sends colour as hex text like "B0452F"; Flutter needs a Color
    color: Color(int.parse('FF${json['color']}', radix: 16)),
    rating: (json['rating'] as num).toDouble(),
    reviews: json['reviews'] as int,
  );
}