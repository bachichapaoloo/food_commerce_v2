import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';

class UpdateAddOnGroupUseCase implements UseCase<Unit, AddOnGroup> {
  final AdminRepository repository;

  UpdateAddOnGroupUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddOnGroup group) async {
    return await repository.updateAddOnGroup(group);
  }
}
