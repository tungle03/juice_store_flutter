import 'package:flutter/material.dart';
import 'cart_store.dart';
import 'checkout_screen.dart';
import 'models.dart';
import 'utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = CartStore.I;

  @override
  Widget build(BuildContext context) {
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Chưa có sản phẩm nào trong giỏ'))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final it = items[index];
                        return _CartItemCard(
                          item: it,
                          onRemove: () {
                            setState(() {
                              cart.remove(it);
                            });
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tạm tính: ${formatPrice(cart.subTotal)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: items.isEmpty
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                          setState(() {});
                        },
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: const Text('Thanh toán'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final toppingText = item.toppings.isEmpty
        ? 'Không topping'
        : item.toppings.entries.map((e) => '${e.key} (+${formatPrice(e.value)})').join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Size: ${item.size}'),
                  Text('Topping: $toppingText'),
                  Text('Đơn giá: ${formatPrice(item.unitPrice)}'),
                  Text('Số lượng: ${item.qty}'),
                  const SizedBox(height: 4),
                  Text('Thành tiền: ${formatPrice(item.lineTotal)}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
