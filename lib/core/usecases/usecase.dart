import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';

// Type: What the UseCase returns (e.g., UserEntity)
// Params: What the UseCase needs to execute (e.g., LoginParams)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
