import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hot_and_souly/models/item.dart';
import 'package:hot_and_souly/cart.dart';

// The live API on Render. For local testing, switch back to
// 'http://localhost:3000' (and run `node server.js`).
const String baseUrl = 'https://hot-and-souly-api.onrender.com';

class ApiService {
  // GET /menu -> list of MenuItem
  static Future<List<MenuItem>> getMenu() async {
    final res = await http.get(Uri.parse('$baseUrl/menu'));
    if (res.statusCode != 200) throw Exception('Failed to load menu');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => MenuItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // POST /orders -> returns the saved order (the server calculates the total)
  static Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String phone,
    required List<CartLine> lines,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerName': name,
        'phone': phone,
        'items': lines.map((l) => {'id': l.item.id, 'qty': l.qty}).toList(),
      }),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 201) throw Exception(body['error'] ?? 'Order failed');
    return body;
  }
}