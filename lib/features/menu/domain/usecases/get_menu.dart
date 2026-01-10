import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/menu_repository.dart';

class GetCategories implements UseCase<List<CategoryEntity>, NoParams> {
  final MenuRepository repository;
  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repository.getCategories();
  }
}

class GetProducts implements UseCase<List<ProductEntity>, int?> {
  final MenuRepository repository;
  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(int? categoryId) {
    return repository.getProducts(categoryId: categoryId);
  }
}
