import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/catalog_filter.dart';
import '../../data/models/product.dart';
import '../../domain/filter_products.dart';
import 'products_provider.dart';

class CatalogFilterNotifier extends StateNotifier<CatalogFilter> {
  CatalogFilterNotifier() : super(const CatalogFilter());

  void setQuery(String query) => state = state.copyWith(query: query);

  void setCategory(String category) =>
      state = state.copyWith(category: category);

  void setSort(ProductSort sort) => state = state.copyWith(sort: sort);

  void reset() => state = const CatalogFilter();
}

final catalogFilterProvider =
    StateNotifierProvider<CatalogFilterNotifier, CatalogFilter>((ref) {
  return CatalogFilterNotifier();
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final filter = ref.watch(catalogFilterProvider);
  return ref.watch(productsProvider).whenData(
        (products) => filterProducts(products, filter),
      );
});
