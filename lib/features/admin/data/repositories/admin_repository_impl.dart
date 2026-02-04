import 'package:dartz/dartz.dart';

import 'package:food_commerce_v2/core/error/exceptions.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'package:food_commerce_v2/features/menu/data/models/product_model.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> createAddOnGroup(AddOnGroup group) async {
    try {
      // Cast entity to model or use a mapper
      final model = AddOnGroupModel(
        id: group.id, // ID might be empty for new creation, handled by datasource?
        name: group.name,
        minSelection: group.minSelection,
        maxSelection: group.maxSelection,
        options: group.options,
      );
      await remoteDataSource.createAddOnGroup(model);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createProduct(ProductEntity product) async {
    try {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
        addOnGroups: product.addOnGroups,
      );
      await remoteDataSource.createProduct(model);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAddOnGroup(String id) async {
    try {
      await remoteDataSource.deleteAddOnGroup(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AddOnGroup>>> getAddOnGroups() async {
    try {
      final result = await remoteDataSource.getAddOnGroups();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final result = await remoteDataSource.getProductById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAddOnGroup(AddOnGroup group) async {
    try {
      final model = AddOnGroupModel(
        id: group.id,
        name: group.name,
        minSelection: group.minSelection,
        maxSelection: group.maxSelection,
        options: group.options,
      );
      await remoteDataSource.updateAddOnGroup(model);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product) async {
    try {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
        addOnGroups: product.addOnGroups,
      );
      await remoteDataSource.updateProduct(model);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
