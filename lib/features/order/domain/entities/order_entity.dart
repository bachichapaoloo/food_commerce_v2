import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/cart/domain/entities/cart_item.dart';

class OrderEntity extends Equatable {
  final int id;
  final double totalPrice;
  final String status;
  final List<CartItemEntity>? items;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.totalPrice,
    required this.status,
    this.items,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, totalPrice, status, items, createdAt];
}
