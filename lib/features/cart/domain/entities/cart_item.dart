import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final List<AddOnOption> selectedAddons;

  const CartItemEntity({required this.product, this.quantity = 1, this.selectedAddons = const []});

  // Helper to calculate total for this specific line item
  double get totalPrice {
    final addonPrice = selectedAddons.fold(0.0, (sum, addon) => sum + addon.priceModifier);
    return (product.price + addonPrice) * quantity;
  }

  // Helper to change quantity (since class is immutable)
  CartItemEntity copyWith({int? quantity, List<AddOnOption>? selectedAddons}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
    );
  }

  @override
  List<Object> get props => [product, quantity, selectedAddons];
}
