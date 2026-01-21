part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class SubmitOrderEvent extends OrderEvent {
  final String userId;
  final List<CartItemEntity> cartItems;
  final double totalBill;

  const SubmitOrderEvent({required this.userId, required this.cartItems, required this.totalBill});

  @override
  List<Object> get props => [userId, cartItems, totalBill];
}

class FetchOrderHistory extends OrderEvent {
  final String userId;

  const FetchOrderHistory({required this.userId});

  @override
  List<Object> get props => [userId];
}
