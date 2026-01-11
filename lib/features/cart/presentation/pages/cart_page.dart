import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../order/presentation/bloc/order_bloc.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // PROVIDE OrderBloc only to this page
    return BlocProvider(create: (_) => sl<OrderBloc>(), child: const _CartView());
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          // Clear cart
          context.read<CartBloc>().add(ClearCart());

          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Text("Order Placed 🎉"),
              content: Text(
                "Order ID: #${state.order.id}\n"
                "Total: \$${state.order.totalPrice.toStringAsFixed(2)}",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // close dialog
                    Navigator.of(context).pop(); // leave cart
                  },
                  child: const Text("Awesome"),
                ),
              ],
            ),
          );
        }

        if (state is OrderFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Cart"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
              },
            ),
          ],
        ),

        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Your cart is empty"),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // CART ITEMS
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.items.length,
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 40),
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      context.read<CartBloc>().add(RemoveItemFromCart(item.product));
                                    },
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      context.read<CartBloc>().add(AddItemToCart(item.product));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL + CHECKOUT
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:", style: TextStyle(fontSize: 18)),
                          Text(
                            "\$${cartState.totalBill.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, orderState) {
                          if (orderState is OrderSubmitting) {
                            return const CircularProgressIndicator();
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _submitOrder(context, cartState),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Checkout", style: TextStyle(fontSize: 18)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submitOrder(BuildContext context, CartState cartState) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must be logged in!")));
      return;
    }

    context.read<OrderBloc>().add(
      SubmitOrderEvent(userId: authState.user.id, cartItems: cartState.items, totalBill: cartState.totalBill),
    );
  }
}
