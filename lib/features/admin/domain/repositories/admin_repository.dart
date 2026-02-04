import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';

abstract class AdminRepository {
  // Product CRUD
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, Unit>> createProduct(ProductEntity product); // Unit is Void
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product);
  Future<Either<Failure, Unit>> deleteProduct(String id);

  // AddOn Group CRUD
  Future<Either<Failure, List<AddOnGroup>>> getAddOnGroups();
  Future<Either<Failure, Unit>> createAddOnGroup(AddOnGroup group);
  Future<Either<Failure, Unit>> updateAddOnGroup(AddOnGroup group);
  Future<Either<Failure, Unit>> deleteAddOnGroup(String id);
}
