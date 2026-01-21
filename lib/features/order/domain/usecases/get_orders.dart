import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

// 1. Change Return Type to List<OrderEntity>
class GetOrders implements UseCase<List<OrderEntity>, GetOrdersParams> {
  final OrderRepository repository;
  GetOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersParams params) {
    return repository.getOrders(userId: params.userId);
  }
}

class GetOrdersParams {
  final String userId;
  GetOrdersParams({required this.userId});
}
