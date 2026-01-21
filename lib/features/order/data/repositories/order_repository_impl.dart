import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
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
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({required String userId}) async {
    try {
      final result = await remoteDataSource.getOrders(userId);
      return Right(
        result.map((model) {
          return OrderEntity(
            id: model.id,
            totalPrice: model.totalPrice,
            status: model.status,
            createdAt: model.createdAt,
            items: model.items?.map((detail) {
              return CartItemEntity(
                product: ProductEntity(
                  id: detail.productId,
                  name: detail.name,
                  price: detail.price,
                  description: '',
                  imageUrl: '',
                  categoryId: 0,
                ),
                quantity: detail.quantity,
              );
            }).toList(),
          );
        }).toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
