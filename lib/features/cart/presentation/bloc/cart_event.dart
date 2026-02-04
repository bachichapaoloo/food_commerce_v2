import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddItemToCart extends CartEvent {
  final ProductEntity product;
  final List<AddOnOption> selectedAddons;
  const AddItemToCart(this.product, {this.selectedAddons = const []});
  @override
  List<Object> get props => [product, selectedAddons];
}

class CheckoutRequested extends CartEvent {
  final String userId;
  const CheckoutRequested(this.userId);
}

class RemoveItemFromCart extends CartEvent {
  final ProductEntity product;
  const RemoveItemFromCart(this.product);
  @override
  List<Object> get props => [product];
}

class RemoveItemCompletely extends CartEvent {
  final ProductEntity product;
  const RemoveItemCompletely(this.product);
  @override
  List<Object> get props => [product];
}

class ClearCart extends CartEvent {}
