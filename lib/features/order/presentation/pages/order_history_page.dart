import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_commerce_v2/features/navigation/main_wrapper_page.dart';
import 'package:food_commerce_v2/features/order/presentation/bloc/order_bloc.dart';
import 'package:food_commerce_v2/features/profile/presentation/pages/profile_page.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    // 1. Trigger the fetch immediately when page opens
    _fetchOrders();
  }

  void _fetchOrders() {
    // Get the User ID securely from the AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrderBloc>().add(FetchOrderHistory(userId: authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainWrapperPage())),
        ),
      ),

      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          // A. Loading State
          if (state is OrderInitial) {
            // Ensure you have this state or reuse 'OrderSubmitting'
            return const Center(child: CircularProgressIndicator());
          }

          // B. Error State
          if (state is OrderFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  ElevatedButton(onPressed: _fetchOrders, child: const Text("Retry")),
                ],
              ),
            );
          }

          // C. Loaded State
          if (state is OrderHistoryLoaded) {
            if (state.orders!.isEmpty) {
              return const Center(child: Text("No past orders found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders!.length,
              itemBuilder: (context, index) {
                final order = state.orders![index];

                // Format date (Optional)
                final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text("Order #${order.id}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          "\$${order.totalPrice.toStringAsFixed(2)} • ${order.status}",
                          style: TextStyle(
                            color: order.status == 'pending' ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      if (order.items != null)
                        ...order.items!.map(
                          (item) => ListTile(
                            visualDensity: VisualDensity.compact,
                            leading: Text("${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold)),
                            title: Text(item.product.name), // Snapshot Name
                            trailing: Text("\$${item.product.price}"), // Snapshot Price
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
