import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/catalog_filter.dart';
import '../providers/cart_provider.dart';
import '../providers/filter_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/async_body.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final filter = ref.watch(catalogFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Shop'),
        actions: const [CartBadgeButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un produit…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) =>
                  ref.read(catalogFilterProvider.notifier).setQuery(v),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c),
                        selected: filter.category == c,
                        onSelected: (_) => ref
                            .read(catalogFilterProvider.notifier)
                            .setCategory(c),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Trier', style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                DropdownButton<ProductSort>(
                  value: filter.sort,
                  underline: const SizedBox.shrink(),
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(catalogFilterProvider.notifier).setSort(v);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ProductSort.relevance,
                      child: Text('Pertinence'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceAsc,
                      child: Text('Prix croissant'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceDesc,
                      child: Text('Prix décroissant'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.rating,
                      child: Text('Mieux notés'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncBody(
              value: filtered,
              onRetry: () => ref.invalidate(productsProvider),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Aucun produit'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    final p = products[i];
                    return ProductCard(
                      product: p,
                      onAddToCart: () {
                        ref.read(cartProvider.notifier).add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} ajouté au panier'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
