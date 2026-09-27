import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get lineTotal => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final Map<String, CartItem> items;

  const CartState({this.items = const {}});

  List<CartItem> get list => items.values.toList();

  int get itemCount => items.values.fold(0, (s, i) => s + i.quantity);

  double get total => items.values.fold(0, (s, i) => s + i.lineTotal);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
