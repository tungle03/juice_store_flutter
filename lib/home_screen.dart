import 'package:flutter/material.dart';
import 'models.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'cart_store.dart';
import 'orders_screen.dart';
import 'utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const products = <Product>[
    Product(id: 'cam', name: 'Cam ép', desc: '100% cam tươi', basePrice: 30000),
    Product(id: 'tao', name: 'Táo ép', desc: 'Táo ngọt, ít chua', basePrice: 35000),
    Product(id: 'carot', name: 'Cà rốt', desc: 'Tươi, tốt cho mắt', basePrice: 28000),
    Product(id: 'detox', name: 'Mix Detox', desc: 'Táo + thơm + cần tây', basePrice: 45000),
    Product(id: 'dua', name: 'Dứa ép', desc: 'Thơm mát, thơm lừng', basePrice: 32000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juice Store'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
            },
            icon: const Icon(Icons.receipt_long),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
              setState(() {});
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (CartStore.I.totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${CartStore.I.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(p.name.substring(0, 1))),
              title: Text(p.name),
              subtitle: Text(p.desc),
              trailing: Text(formatPrice(p.basePrice)),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                );
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
