import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void add(Product product) {
    final current = state.items[product.id];
    final nextQty = (current?.quantity ?? 0) + 1;
    if (nextQty > product.stock) return;
    final next = Map<String, CartItem>.from(state.items);
    next[product.id] = CartItem(product: product, quantity: nextQty);
    state = state.copyWith(items: next);
  }

  void remove(String productId) {
    final next = Map<String, CartItem>.from(state.items)..remove(productId);
    state = state.copyWith(items: next);
  }

  void setQuantity(String productId, int quantity) {
    if (!state.items.containsKey(productId)) return;
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    final item = state.items[productId]!;
    final qty = quantity.clamp(1, item.product.stock);
    final next = Map<String, CartItem>.from(state.items);
    next[productId] = item.copyWith(quantity: qty);
    state = state.copyWith(items: next);
  }

  void clear() => state = const CartState();
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});
