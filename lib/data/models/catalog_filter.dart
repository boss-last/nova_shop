enum ProductSort { relevance, priceAsc, priceDesc, rating }

class CatalogFilter {
  final String query;
  final String category;
  final ProductSort sort;

  const CatalogFilter({
    this.query = '',
    this.category = 'Tous',
    this.sort = ProductSort.relevance,
  });

  CatalogFilter copyWith({
    String? query,
    String? category,
    ProductSort? sort,
  }) {
    return CatalogFilter(
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}
