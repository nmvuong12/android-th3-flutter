import 'category.dart';

class Product {
  final int id;
  final String name;
  final String desc;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      desc: json['desc'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: json['category'] != null 
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'desc': desc,
      'price': price,
      if (category != null) 'category': {'id': category!.id},
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'desc': desc,
      'price': price,
      if (category != null) 'category': {'id': category!.id},
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? desc,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }
}
