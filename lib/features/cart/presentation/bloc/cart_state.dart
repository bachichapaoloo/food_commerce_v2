part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  // Computed property: easier than managing a separate variable
  double get totalBill => items.fold(0, (sum, item) => sum + item.totalPrice);

  // Computed property: total count of items (e.g. 2 burgers + 1 drink = 3 items)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [items];
}
