import 'package:flutter/material.dart';
import 'models.dart';
import 'cart_store.dart';
import 'utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _size = 'M';
  int _qty = 1;

  // ✅ Toppings phải là Map<String,int> (tên -> giá)
  final Map<String, int> _selectedToppings = {};

  // Options demo (bro muốn đổi giá thì đổi ở đây)
  final Map<String, int> _toppingOptions = const {
    'Trân châu': 5000,
    'Thạch': 3000,
    'Pudding': 6000,
    'Kem cheese': 7000,
  };

  // Size extra demo
  int get _sizeExtra {
    switch (_size) {
      case 'S':
        return 0;
      case 'M':
        return 5000;
      case 'L':
        return 10000;
      default:
        return 0;
    }
  }

  int get _toppingTotal =>
      _selectedToppings.values.fold<int>(0, (s, v) => s + v);

  int get _unitPrice =>
      widget.product.basePrice + _sizeExtra + _toppingTotal;

  int get _lineTotal => _unitPrice * _qty;

  void _toggleTopping(String name, int price, bool checked) {
    setState(() {
      if (checked) {
        _selectedToppings[name] = price;
      } else {
        _selectedToppings.remove(name);
      }
    });
  }

  void _addToCart() {
    final item = CartItem(
      product: widget.product,
      size: _size,
      qty: _qty,
      sizeExtra: _sizeExtra,
      toppings: Map<String, int>.from(_selectedToppings),
    );

    CartStore.I.add(item);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            p.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(p.desc),
          const SizedBox(height: 12),
          Text('Giá gốc: ${formatPrice(p.basePrice)}'),
          const SizedBox(height: 16),

          // SIZE
          const Text(
            'Chọn size',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['S', 'M', 'L'].map((s) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text('$s ${s == "S" ? "" : "(+${formatPrice(s == "M" ? 5000 : 10000)})"}'),
                  value: s,
                  groupValue: _size,
                  onChanged: (v) => setState(() => _size = v!),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // TOPPINGS
          const Text(
            'Topping',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._toppingOptions.entries.map((e) {
            final checked = _selectedToppings.containsKey(e.key);
            return CheckboxListTile(
              title: Text('${e.key} (+${formatPrice(e.value)})'),
              value: checked,
              onChanged: (v) => _toggleTopping(e.key, e.value, v ?? false),
              contentPadding: EdgeInsets.zero,
            );
          }),

          const SizedBox(height: 16),

          // QTY
          const Text(
            'Số lượng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: _qty <= 1 ? null : () => setState(() => _qty--),
                icon: const Icon(Icons.remove),
              ),
              Text('$_qty', style: const TextStyle(fontSize: 18)),
              IconButton(
                onPressed: () => setState(() => _qty++),
                icon: const Icon(Icons.add),
              ),
              const Spacer(),
              Text(
                'Thành tiền: ${formatPrice(_lineTotal)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _addToCart,
            child: const Text('Thêm vào giỏ'),
          ),
        ],
      ),
    );
  }
}
