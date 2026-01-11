// Inside place_order.dart
import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/cart/domain/entities/cart_item.dart';
import 'package:food_commerce_v2/features/order/domain/entities/order_entity.dart';
import 'package:food_commerce_v2/features/order/domain/repositories/order_repository.dart';

class PlaceOrder implements UseCase<OrderEntity, PlaceOrderParams> {
  final OrderRepository repository;
  PlaceOrder(this.repository);

  @override
  @override
  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) {
    return repository.placeOrder(userId: params.userId, items: params.items, total: params.totalAmount);
  }
}

// This is the class the BLoC uses to bundle the data
class PlaceOrderParams {
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;

  PlaceOrderParams({required this.userId, required this.items, required this.totalAmount});
}
