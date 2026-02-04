// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final CartStatus status;
  final String? errorMessage;

  const CartState({this.items = const [], this.status = CartStatus.initial, this.errorMessage});

  // Computed property: easier than managing a separate variable
  double get totalBill => items.fold(0, (sum, item) => sum + item.totalPrice);

  // Computed property: total count of items (e.g. 2 burgers + 1 drink = 3 items)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [items];

  CartState copyWith({List<CartItemEntity>? items, CartStatus? status, String? errorMessage}) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
