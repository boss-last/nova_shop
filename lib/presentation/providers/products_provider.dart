import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product.dart';
import 'repository_providers.dart';

/// Catalogue async — exposé via AsyncValue dans l'UI.
final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final productByIdProvider =
    FutureProvider.family<Product, String>((ref, id) {
  return ref.watch(productRepositoryProvider).getProduct(id);
});

final categoriesProvider = Provider<List<String>>((ref) {
  final async = ref.watch(productsProvider);
  return async.maybeWhen(
    data: (products) {
      final cats = products.map((p) => p.category).toSet().toList()..sort();
      return ['Tous', ...cats];
    },
    orElse: () => const ['Tous'],
  );
});
