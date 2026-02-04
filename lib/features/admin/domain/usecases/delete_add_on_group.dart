import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';

class DeleteAddOnGroupUseCase implements UseCase<Unit, String> {
  final AdminRepository repository;

  DeleteAddOnGroupUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteAddOnGroup(id);
  }
}
