import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository.dart';

final productDatasourceProvider = Provider<ProductLocalDatasource>((ref) {
  return ProductLocalDatasource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(productDatasourceProvider));
});
