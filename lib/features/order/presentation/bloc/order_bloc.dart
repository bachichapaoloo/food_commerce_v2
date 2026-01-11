import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/place_order.dart'; // Import your UseCase

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrder placeOrder;

  OrderBloc({required this.placeOrder}) : super(OrderInitial()) {
    on<SubmitOrderEvent>(_onSubmitOrder);
  }

  Future<void> _onSubmitOrder(SubmitOrderEvent event, Emitter<OrderState> emit) async {
    // 1. Show Loading Indicator
    emit(OrderSubmitting());

    // 2. Call the Domain Layer
    // We wrap the data into the Params object expected by the UseCase
    final result = await placeOrder(
      PlaceOrderParams(userId: event.userId, items: event.cartItems, totalAmount: event.totalBill),
    );

    // 3. Handle Result
    result.fold(
      (failure) => emit(OrderFailure(failure.message)), // Error
      (order) => emit(OrderSuccess(order)), // Success
    );
  }
}
