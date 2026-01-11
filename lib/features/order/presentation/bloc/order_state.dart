part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderSubmitting extends OrderState {}

class OrderSuccess extends OrderState {
  // We can pass the created order back if we want to show a receipt page
  final OrderEntity order;

  const OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);

  @override
  List<Object> get props => [message];
}
