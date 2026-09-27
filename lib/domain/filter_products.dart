import '../data/models/catalog_filter.dart';
import '../data/models/product.dart';

/// Logique métier : filtrage + tri (hors widgets).
List<Product> filterProducts(List<Product> products, CatalogFilter filter) {
  var list = products.where((p) {
    final q = filter.query.trim().toLowerCase();
    final matchQuery = q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q);
    final matchCat = filter.category == 'Tous' || p.category == filter.category;
    return matchQuery && matchCat;
  }).toList();

  switch (filter.sort) {
    case ProductSort.priceAsc:
      list.sort((a, b) => a.price.compareTo(b.price));
    case ProductSort.priceDesc:
      list.sort((a, b) => b.price.compareTo(a.price));
    case ProductSort.rating:
      list.sort((a, b) => b.rating.compareTo(a.rating));
    case ProductSort.relevance:
      break;
  }
  return list;
}
