import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, void>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double total,
  });
}
