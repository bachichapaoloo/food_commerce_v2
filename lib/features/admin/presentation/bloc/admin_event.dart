import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminData extends AdminEvent {} // Loads products and addon groups

// Product Events
class CreateProduct extends AdminEvent {
  final ProductEntity product;
  const CreateProduct(this.product);
  @override
  List<Object> get props => [product];
}

class UpdateProduct extends AdminEvent {
  final ProductEntity product;
  const UpdateProduct(this.product);
  @override
  List<Object> get props => [product];
}

class DeleteProduct extends AdminEvent {
  final String id;
  const DeleteProduct(this.id);
  @override
  List<Object> get props => [id];
}

// AddOn Events
class CreateAddOnGroup extends AdminEvent {
  final AddOnGroup group;
  const CreateAddOnGroup(this.group);
  @override
  List<Object> get props => [group];
}

class UpdateAddOnGroup extends AdminEvent {
  final AddOnGroup group;
  const UpdateAddOnGroup(this.group);
  @override
  List<Object> get props => [group];
}

class DeleteAddOnGroup extends AdminEvent {
  final String id;
  const DeleteAddOnGroup(this.id);
  @override
  List<Object> get props => [id];
}
