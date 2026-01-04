import 'models.dart';

class CartStore {
  CartStore._();
  static final CartStore I = CartStore._();

  final List<CartItem> items = [];

  int get subTotal => items.fold<int>(0, (s, e) => s + e.lineTotal);

  // ✅ Badge count
  int get totalItems => items.fold<int>(0, (s, e) => s + e.qty);

  void add(CartItem item) {
    final idx = items.indexWhere((x) =>
        x.product.id == item.product.id &&
        x.size == item.size &&
        _sameToppings(x.toppings, item.toppings));

    if (idx >= 0) {
      // qty là final -> tạo object mới
      final old = items[idx];
      items[idx] = _copyWithQty(old, old.qty + item.qty);
    } else {
      items.add(item);
    }
  }

  void inc(int index) {
    final old = items[index];
    items[index] = _copyWithQty(old, old.qty + 1);
  }

  void dec(int index) {
    final old = items[index];
    final newQty = old.qty - 1;
    if (newQty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = _copyWithQty(old, newQty);
    }
  }

  void removeAt(int index) => items.removeAt(index);

  // ✅ thêm remove nếu cart_screen.dart đang gọi CartStore.I.remove(...)
  void remove(CartItem item) {
    final idx = items.indexWhere((x) =>
        x.product.id == item.product.id &&
        x.size == item.size &&
        _sameToppings(x.toppings, item.toppings));
    if (idx >= 0) items.removeAt(idx);
  }

  void clear() => items.clear();

  CartItem _copyWithQty(CartItem old, int qty) => CartItem(
        product: old.product,
        size: old.size,
        qty: qty,
        sizeExtra: old.sizeExtra,
        toppings: Map<String, int>.from(old.toppings),
      );

  bool _sameToppings(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (!b.containsKey(k)) return false;
      if (a[k] != b[k]) return false;
    }
    return true;
  }
}
