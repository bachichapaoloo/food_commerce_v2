import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String imageUrl;

  const CategoryEntity({required this.id, required this.name, required this.imageUrl});

  @override
  List<Object?> get props => [id, name, imageUrl];
}

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int categoryId;
  final List<AddOnGroup> addOnGroups;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.addOnGroups = const [],
  });

  @override
  List<Object?> get props => [id, name, description, price, categoryId, imageUrl, addOnGroups];
}
