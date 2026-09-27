import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/async_body.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final cartCount = ref.watch(cartItemCountProvider);
    final favCount = ref.watch(favoritesProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: AsyncBody(
        value: profile,
        onRetry: () => ref.invalidate(userProfileProvider),
        data: (user) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text('Ville'),
                      subtitle: Text(user.city),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Membre depuis'),
                      subtitle: Text(user.memberSince),
                    ),
                    ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Commandes'),
                      subtitle: Text('${user.ordersCount} commandes'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text('Articles dans le panier'),
                      trailing: Text('$cartCount'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text('Favoris'),
                      trailing: Text('$favCount'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Compte de démonstration (données mockées).',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
