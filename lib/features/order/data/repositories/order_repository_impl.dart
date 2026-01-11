import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import '../../../../core/error/exceptions.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double total,
  }) async {
    try {
      final result = await remoteDataSource.placeOrder(userId, items, total);
      return Right(
        OrderEntity(id: result.id, totalPrice: result.totalPrice, status: result.status, createdAt: result.createdAt),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Catch-all for unexpected errors
      return Left(ServerFailure(e.toString()));
    }
  }
}
