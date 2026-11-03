import 'package:flutter/material.dart';

import 'api_service.dart';
import 'models/item.dart';

// One row in the cart: a dish and how many of it.
class CartLine {
  final MenuItem item;
  int qty;
  CartLine(this.item, this.qty);
}

// Holds everything the customer added.
// ChangeNotifier lets widgets listen and redraw when the cart changes.
class CartModel extends ChangeNotifier {
  // key = dish id, so adding the same dish twice just raises its quantity
  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList();

  // total number of items (shown on the cart button)
  int get count => _lines.values.fold<int>(0, (sum, l) => sum + l.qty);

  // total price in KSh
  double get total =>
      _lines.values.fold<double>(0, (sum, l) => sum + l.item.price * l.qty);

  void add(MenuItem item) {
    _lines.update(
      item.id,
          (line) {
        line.qty++;
        return line;
      },
      ifAbsent: () => CartLine(item, 1),
    );
    notifyListeners(); // tell listeners to redraw
  }

  void remove(MenuItem item) {
    final line = _lines[item.id];
    if (line == null) return;
    line.qty--;
    if (line.qty <= 0) _lines.remove(item.id);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}

// One shared cart for the whole app.
final cart = CartModel();

// Slides up from the bottom and lists the cart.
void showCartSheet(BuildContext context) {
  const dark = Color(0xFF14110F);
  const rust = Color(0xFFB5472F);
  const gold = Color(0xFFE3B341);

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFCF7),
    isScrollControlled: true,
    builder: (sheetContext) {
      // rebuilds whenever the cart changes (+ / - buttons)
      // `context` = the page (stays alive), `sheetContext` = this bottom sheet
      return ListenableBuilder(
        listenable: cart,
        builder: (_, __) {
          final lines = cart.lines;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your order",
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 16),

                if (lines.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text("Your cart is empty.")),
                  )
                else
                // limits the list height so the sheet can scroll
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final line in lines)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              line.item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'KSh ${(line.item.price * line.qty).toStringAsFixed(0)}',
                              style: const TextStyle(color: rust),
                            ),
                            // minus, quantity, plus
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.remove(line.item),
                                ),
                                Text('${line.qty}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.add(line.item),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'KSh ${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: rust,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // opens the checkout dialog, which sends the order to the Node API
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: lines.isEmpty
                        ? null
                        : () => _checkout(context, sheetContext),
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: dark,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text("Place order"),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ---------- checkout ----------

// Step 1: ask for name + phone. Step 2: send the order to the API.
// Step 3: empty the cart, close the sheet and show a confirmation.
Future<void> _checkout(BuildContext context, BuildContext sheetContext) async {
  // the dialog returns the saved order (a Map) or null if cancelled
  final order = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _CheckoutDialog(lines: cart.lines),
  );
  if (order == null || !context.mounted) return;

  cart.clear();
  if (sheetContext.mounted) Navigator.pop(sheetContext); // close the cart sheet

  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFFFFFCF7),
      title: Text(
        'Order #${order['id']} received!',
        style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Total: KSh ${(order['total'] as num).toStringAsFixed(0)}\n'
            "We'll call you on ${order['phone']} to confirm.",
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE3B341),
            foregroundColor: const Color(0xFF14110F),
          ),
          child: const Text('Great'),
        ),
      ],
    ),
  );
}

// The name + phone form. It's a StatefulWidget because it must remember
// what was typed and whether the request is in progress.
class _CheckoutDialog extends StatefulWidget {
  final List<CartLine> lines;
  const _CheckoutDialog({required this.lines});

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _sending = false; // true while the request is on its way
  String? _error; // message from the server or the network

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // run the validators below; stop if any field is wrong
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final order = await ApiService.placeOrder(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        lines: widget.lines,
      );
      if (mounted) Navigator.pop(context, order); // hand the order back
    } catch (e) {
      final text = e.toString();
      setState(() {
        _sending = false;
        // "Exception: ..." = a message from our own API; anything else = network
        _error = text.startsWith('Exception: ')
            ? text.replaceFirst('Exception: ', '')
            : 'Could not reach the server. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFFCF7),
      title: const Text(
        'Almost there',
        style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  hintText: '0712345678',
                  border: OutlineInputBorder(),
                ),
                // same rule the server uses: 9-15 digits, may include + space -
                validator: (v) => RegExp(r'^[0-9+\s-]{9,15}$').hasMatch(v?.trim() ?? '')
                    ? null
                    : 'Enter a valid phone number',
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _sending ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE3B341),
            foregroundColor: const Color(0xFF14110F),
          ),
          child: _sending
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Send order'),
        ),
      ],
    );
  }
}