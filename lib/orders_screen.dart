import 'package:flutter/material.dart';
import 'models.dart';
import 'order_store.dart';
import 'utils.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _fmtTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderStore.I.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng')),
      body: orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final o = orders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${o.customerName} • ${o.phone}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Mã: ${o.id} • ${_fmtTime(o.createdAt)}'),
                        const SizedBox(height: 8),
                        ...o.items.map((it) => Text(
                              '- ${it.product.name} (${it.size}) x${it.qty}: ${formatPrice(it.lineTotal)}',
                            )),
                        const Divider(),
                        Text(
                          'Tổng: ${formatPrice(o.total)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
