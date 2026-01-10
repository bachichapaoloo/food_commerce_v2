import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/exceptions.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:food_commerce_v2/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    // TODO: implement getCategories
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int? categoryId}) async {
    // TODO: implement getProducts
    try {
      final products = await remoteDataSource.getProducts(categoryId: categoryId);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
