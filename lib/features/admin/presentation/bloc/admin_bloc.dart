import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository adminRepository;

  AdminBloc({required this.adminRepository}) : super(AdminInitial()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<CreateAddOnGroup>(_onCreateAddOnGroup);
    on<UpdateAddOnGroup>(_onUpdateAddOnGroup);
    on<DeleteAddOnGroup>(_onDeleteAddOnGroup);
  }

  Future<void> _onLoadAdminData(LoadAdminData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final productsResult = await adminRepository.getProducts();
    final addonsResult = await adminRepository.getAddOnGroups();

    productsResult.fold((failure) => emit(AdminError(failure.message)), (products) {
      addonsResult.fold(
        (failure) => emit(AdminError(failure.message)),
        (addons) => emit(AdminLoaded(products: products, addOnGroups: addons)),
      );
    });
  }

  Future<void> _onCreateProduct(CreateProduct event, Emitter<AdminState> emit) async {
    // Optimistic or refresh? Refresh for now.
    emit(AdminLoading());
    final result = await adminRepository.createProduct(event.product);
    result.fold((failure) => emit(AdminError(failure.message)), (_) {
      // emit(const AdminSuccess("Product Created")); // Careful with state flow
      add(LoadAdminData());
    });
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await adminRepository.updateProduct(event.product);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await adminRepository.deleteProduct(event.id);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onCreateAddOnGroup(CreateAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await adminRepository.createAddOnGroup(event.group);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onUpdateAddOnGroup(UpdateAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await adminRepository.updateAddOnGroup(event.group);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onDeleteAddOnGroup(DeleteAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await adminRepository.deleteAddOnGroup(event.id);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }
}
