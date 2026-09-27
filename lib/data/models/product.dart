class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final double rating;
  final int stock;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.rating,
    required this.stock,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  bool get inStock => stock > 0;
}
