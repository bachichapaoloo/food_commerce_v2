import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/create_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/create_product.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/delete_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/delete_product.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/get_add_on_groups.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/get_admin_products.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/update_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/update_product.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAdminProducts getAdminProducts;
  final CreateProductUseCase createProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  final GetAddOnGroups getAddOnGroups;
  final CreateAddOnGroupUseCase createAddOnGroup;
  final UpdateAddOnGroupUseCase updateAddOnGroup;
  final DeleteAddOnGroupUseCase deleteAddOnGroup;

  AdminBloc({
    required this.getAdminProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getAddOnGroups,
    required this.createAddOnGroup,
    required this.updateAddOnGroup,
    required this.deleteAddOnGroup,
  }) : super(AdminInitial()) {
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
    final productsResult = await getAdminProducts(NoParams());
    final addonsResult = await getAddOnGroups(NoParams());

    productsResult.fold((failure) => emit(AdminError(failure.message)), (products) {
      addonsResult.fold(
        (failure) => emit(AdminError(failure.message)),
        (addons) => emit(AdminLoaded(products: products, addOnGroups: addons)),
      );
    });
  }

  Future<void> _onCreateProduct(CreateProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await createProduct(event.product);
    result.fold((failure) => emit(AdminError(failure.message)), (_) {
      add(LoadAdminData());
    });
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await updateProduct(event.product);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await deleteProduct(event.id);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onCreateAddOnGroup(CreateAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await createAddOnGroup(event.group);
    result.fold((failure) {
      print("Bloc Error Create Group: ${failure.message}");
      emit(AdminError(failure.message));
    }, (_) => add(LoadAdminData()));
  }

  Future<void> _onUpdateAddOnGroup(UpdateAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await updateAddOnGroup(event.group);
    result.fold((failure) => emit(AdminError(failure.message)), (_) => add(LoadAdminData()));
  }

  Future<void> _onDeleteAddOnGroup(DeleteAddOnGroup event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await deleteAddOnGroup(event.id);
    result.fold((failure) {
      print("Bloc Error Delete Group: ${failure.message}");
      emit(AdminError(failure.message));
    }, (_) => add(LoadAdminData()));
  }
}
