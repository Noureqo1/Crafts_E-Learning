class CraftItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String sellerName;
  final String? imageUrl;
  final String category;
  final int stock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final bool isAvailable;

  CraftItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.sellerName,
    required this.category,
    this.imageUrl,
    this.stock = 1,
    this.rating = 0.0,
    this.reviewCount = 0,
    DateTime? createdAt,
    this.isAvailable = true,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  factory CraftItem.fromMap(Map<String, dynamic> map) {
    return CraftItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      sellerId: map['sellerId'],
      sellerName: map['sellerName'],
      imageUrl: map['imageUrl'],
      category: map['category'],
      stock: map['stock'] ?? 1,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  CraftItem copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? sellerId,
    String? sellerName,
    String? imageUrl,
    String? category,
    int? stock,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    bool? isAvailable,
  }) {
    return CraftItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  // Helper methods
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  
  String get availabilityStatus {
    if (!isAvailable) return 'Out of Stock';
    if (stock == 0) return 'Out of Stock';
    if (stock < 5) return 'Only $stock left';
    return 'In Stock';
  }
  
  bool get isLowStock => stock > 0 && stock < 5;
}
