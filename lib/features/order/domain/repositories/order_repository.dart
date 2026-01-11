import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import '../../domain/entities/order_entity.dart';
import '../../../cart/domain/entities/cart_item.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double total,
  });
}
