import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItemToCart>(_onAddItem);
    on<RemoveItemFromCart>(_onRemoveItem);
    on<RemoveItemCompletely>(_onRemoveItemCompletely);
    on<ClearCart>((event, emit) => emit(const CartState()));
  }

  void _onAddItem(AddItemToCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);

    // Check if item already exists
    final index = currentItems.indexWhere((item) => item.product.id == event.product.id);

    if (index >= 0) {
      // Exists: Increment quantity
      final existingItem = currentItems[index];
      currentItems[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      // New: Add to list
      currentItems.add(CartItemEntity(product: event.product));
    }

    emit(CartState(items: currentItems));
  }

  void _onRemoveItem(RemoveItemFromCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == event.product.id);

    if (index >= 0) {
      final existingItem = currentItems[index];
      if (existingItem.quantity > 1) {
        // Decrease quantity
        currentItems[index] = existingItem.copyWith(quantity: existingItem.quantity - 1);
      } else {
        // Remove completely
        currentItems.removeAt(index);
      }
      emit(CartState(items: currentItems));
    }
  }

  void _onRemoveItemCompletely(RemoveItemCompletely event, Emitter<CartState> emit) {
    final updatedItems = List<CartItemEntity>.from(state.items)
      ..removeWhere((item) => item.product.id == event.product.id);

    emit(state.copyWith(items: updatedItems));
  }
}
