import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      // Supabase numeric comes as num/int/double, safer to parse like this:
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      categoryId: json['category_id'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name, required super.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name'], imageUrl: json['image_url'] ?? '');
  }
}
