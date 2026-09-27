import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

/// Fake API : JSON local + latence simulée.
class ProductLocalDatasource {
  static const _delay = Duration(milliseconds: 700);

  Future<List<Product>> fetchProducts() async {
    await Future<void>.delayed(_delay);
    final raw = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw StateError('Produit introuvable : $id'),
    );
  }

  Future<UserProfile> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const UserProfile(
      id: 'u1',
      name: 'Amara Christian Bamba',
      email: 'amara@novashop.dev',
      city: 'Abidjan, Côte d\'Ivoire',
      avatarUrl: 'https://i.pravatar.cc/200?u=nova-shop',
      memberSince: 'Mars 2025',
      ordersCount: 7,
    );
  }
}
