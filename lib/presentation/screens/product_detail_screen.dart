import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/format.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/async_body.dart';
import '../widgets/cart_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productByIdProvider(productId));
    final isFav = ref.watch(favoritesProvider).valueOrNull?.contains(productId) ??
        false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Détail'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(productId),
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
          ),
          const CartBadgeButton(),
        ],
      ),
      body: AsyncBody(
        value: async,
        onRetry: () => ref.invalidate(productByIdProvider(productId)),
        data: (product) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              Text(product.category,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
              Text(product.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(product.rating.toStringAsFixed(1)),
                  const Spacer(),
                  Text(
                    euro.format(product.price),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(product.description),
              const SizedBox(height: 12),
              Text(
                product.inStock
                    ? '${product.stock} en stock'
                    : 'Rupture de stock',
                style: TextStyle(
                  color: product.inStock
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: product.inStock
                    ? () {
                        ref.read(cartProvider.notifier).add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ajouté au panier'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Ajouter au panier'),
              ),
            ],
          );
        },
      ),
    );
  }
}
