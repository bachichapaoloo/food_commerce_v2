import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({required this.product, this.quantity = 1});

  // Helper to calculate total for this specific line item
  double get totalPrice => product.price * quantity;

  // Helper to change quantity (since class is immutable)
  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(product: product, quantity: quantity ?? this.quantity);
  }

  @override
  List<Object> get props => [product, quantity];
}
