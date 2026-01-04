import 'models.dart';

class OrderStore {
  OrderStore._();

  // ✅ FIX: để gọi OrderStore.I
  static final OrderStore I = OrderStore._();

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void add(Order order) {
    _orders.insert(0, order);
  }

  void clear() {
    _orders.clear();
  }
}
