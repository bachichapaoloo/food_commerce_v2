import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';

class GetAddOnGroups implements UseCase<List<AddOnGroup>, NoParams> {
  final AdminRepository repository;

  GetAddOnGroups(this.repository);

  @override
  Future<Either<Failure, List<AddOnGroup>>> call(NoParams params) async {
    return await repository.getAddOnGroups();
  }
}
