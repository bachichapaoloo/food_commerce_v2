import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<UserEntity, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await repository.registerWithEmailPassword(
      username: params.username,
      email: params.email,
      password: params.email,
    );
  }
}

class RegisterUserParams {
  final String username;
  final String email;
  final String password;

  RegisterUserParams({required this.username, required this.email, required this.password});
}
