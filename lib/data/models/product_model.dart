class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int reviewCount;
  final String brand;
  final String processor;
  final String ram;
  final String storage;
  final String graphics;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.brand = '',
    this.processor = '',
    this.ram = '',
    this.storage = '',
    this.graphics = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      brand: json['brand'] ?? '',
      processor: json['processor'] ?? '',
      ram: json['ram'] ?? '',
      storage: json['storage'] ?? '',
      graphics: json['graphics'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'brand': brand,
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'graphics': graphics,
    };
  }
}