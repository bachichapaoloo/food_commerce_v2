import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({required String email, required String password});

  Future<Either<Failure, UserEntity>> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<Failure, void>> logout();

  // Useful to check if user is already logged in on app start
  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> signInWithGoogle();
}
