import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

class CreateProductUseCase implements UseCase<Unit, ProductEntity> {
  final AdminRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    return await repository.createProduct(product);
  }
}
