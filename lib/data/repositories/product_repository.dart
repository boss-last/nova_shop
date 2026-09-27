import '../datasources/product_local_datasource.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class ProductRepository {
  ProductRepository(this._datasource);

  final ProductLocalDatasource _datasource;

  Future<List<Product>> getProducts() => _datasource.fetchProducts();

  Future<Product> getProduct(String id) => _datasource.fetchProductById(id);

  Future<UserProfile> getProfile() => _datasource.fetchProfile();
}
