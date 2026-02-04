import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
    super.addOnGroups,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      categoryId: json['category_id'],
      addOnGroups: json['add_on_groups'] != null
          ? (json['add_on_groups'] as List).map((i) => AddOnGroupModel.fromMap(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'add_on_groups': addOnGroups.map((group) {
        return (group is AddOnGroupModel) ? group.toMap() : _addOnGroupToMap(group);
      }).toList(),
    };
  }

  // Helper if domain entity is passed directly (fallback)
  static Map<String, dynamic> _addOnGroupToMap(AddOnGroup group) {
    return {
      'id': group.id,
      'name': group.name,
      'min_selection': group.minSelection,
      'max_selection': group.maxSelection,
      'options': group.options.map((o) => {'id': o.id, 'name': o.name, 'price_modifier': o.priceModifier}).toList(),
    };
  }
}

class AddOnGroupModel extends AddOnGroup {
  const AddOnGroupModel({
    required super.id,
    required super.name,
    required super.minSelection,
    required super.maxSelection,
    required super.options,
  });

  factory AddOnGroupModel.fromMap(Map<String, dynamic> map) {
    return AddOnGroupModel(
      id: map['id'],
      name: map['name'],
      minSelection: map['min_selection'] ?? 0,
      maxSelection: map['max_selection'] ?? 1,
      options: map['options'] != null ? (map['options'] as List).map((x) => AddOnOptionModel.fromMap(x)).toList() : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'min_selection': minSelection,
      'max_selection': maxSelection,
      'options': options.map((x) => (x as AddOnOptionModel).toMap()).toList(),
    };
  }
}

class AddOnOptionModel extends AddOnOption {
  const AddOnOptionModel({required super.id, required super.name, super.priceModifier});

  factory AddOnOptionModel.fromMap(Map<String, dynamic> map) {
    return AddOnOptionModel(
      id: map['id'],
      name: map['name'],
      priceModifier: (map['price_modifier'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price_modifier': priceModifier};
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name, required super.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name'], imageUrl: json['image_url'] ?? '');
  }
}
