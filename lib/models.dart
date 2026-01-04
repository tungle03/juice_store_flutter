class Product {
  final String id;
  final String name;
  final String desc;
  final int basePrice;

  const Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.basePrice,
  });
}

class CartItem {
  final Product product;
  final String size; // "S", "M", "L"
  final int qty;
  final int sizeExtra; // cộng thêm theo size
  final Map<String, int> toppings; // tên -> giá

  const CartItem({
    required this.product,
    required this.size,
    required this.qty,
    required this.sizeExtra,
    required this.toppings,
  });

  // ✅ Thêm copyWith để không cần mutate qty (qty đang final)
  CartItem copyWith({
    Product? product,
    String? size,
    int? qty,
    int? sizeExtra,
    Map<String, int>? toppings,
  }) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      qty: qty ?? this.qty,
      sizeExtra: sizeExtra ?? this.sizeExtra,
      toppings: toppings ?? this.toppings,
    );
  }

  int get toppingTotal => toppings.values.fold<int>(0, (sum, v) => sum + v);

  int get unitPrice => product.basePrice + sizeExtra + toppingTotal;

  int get lineTotal => unitPrice * qty;

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'desc': product.desc,
          'basePrice': product.basePrice,
        },
        'size': size,
        'qty': qty,
        'sizeExtra': sizeExtra,
        'toppings': toppings,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product(
          id: json['product']['id'],
          name: json['product']['name'],
          desc: json['product']['desc'],
          basePrice: json['product']['basePrice'],
        ),
        size: json['size'],
        qty: json['qty'],
        sizeExtra: json['sizeExtra'],
        toppings: Map<String, int>.from(json['toppings'] ?? {}),
      );
}

class Order {
  final String id;
  final String customerName;
  final String phone;
  final List<CartItem> items;
  final int total;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'phone': phone,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        customerName: json['customerName'],
        phone: json['phone'],
        items: (json['items'] as List)
            .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        total: json['total'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
