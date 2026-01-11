part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddItemToCart extends CartEvent {
  final ProductEntity product;
  const AddItemToCart(this.product);
  @override
  List<Object> get props => [product];
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

class ClearCart extends CartEvent {}
