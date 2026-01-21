import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/order/domain/usecases/get_orders.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/place_order.dart'; // Import your UseCase

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrder placeOrder;
  final GetOrders getOrders;

  OrderBloc({required this.placeOrder, required this.getOrders}) : super(OrderInitial()) {
    on<SubmitOrderEvent>(_onSubmitOrder);
    on<FetchOrderHistory>(_onFetchOrderHistory);
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

  Future<void> _onFetchOrderHistory(FetchOrderHistory event, Emitter<OrderState> emit) async {
    // Implementation for fetching order history can be added here
    emit(OrderHistoryLoaded([]));

    final result = await getOrders(GetOrdersParams(userId: event.userId));
    result.fold((failure) => emit(OrderFailure(failure.message)), (orders) => emit(OrderHistoryLoaded(orders)));
  }
}
