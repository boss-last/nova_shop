import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product.dart';
import 'products_provider.dart';

class FavoritesNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  FavoritesNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  static const _key = 'nova_shop_favorites';

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_key)?.toSet() ?? <String>{};
    });
  }

  Future<void> toggle(String productId) async {
    final current = state.valueOrNull ?? <String>{};
    final next = Set<String>.from(current);
    if (!next.add(productId)) next.remove(productId);
    state = AsyncValue.data(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
  }

  bool contains(String productId) =>
      state.valueOrNull?.contains(productId) ?? false;
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<Set<String>>>((ref) {
  return FavoritesNotifier();
});

final favoriteProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final favs = ref.watch(favoritesProvider);
  final products = ref.watch(productsProvider);
  return favs.when(
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
    data: (ids) => products.whenData(
      (list) => list.where((p) => ids.contains(p.id)).toList(),
    ),
  );
});
