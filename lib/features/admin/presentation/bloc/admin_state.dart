import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<ProductEntity> products;
  final List<AddOnGroup> addOnGroups;

  const AdminLoaded({this.products = const [], this.addOnGroups = const []});

  @override
  List<Object> get props => [products, addOnGroups];

  AdminLoaded copyWith({List<ProductEntity>? products, List<AddOnGroup>? addOnGroups}) {
    return AdminLoaded(products: products ?? this.products, addOnGroups: addOnGroups ?? this.addOnGroups);
  }
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
  @override
  List<Object> get props => [message];
}

class AdminSuccess extends AdminState {
  // Transient state for showing success messages (e.g. "Product Added")
  // Might be better handled via Listener or separate status field
  final String message;
  const AdminSuccess(this.message);
  @override
  List<Object> get props => [message];
}
