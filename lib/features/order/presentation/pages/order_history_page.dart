import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_commerce_v2/features/navigation/main_wrapper_page.dart';
import 'package:food_commerce_v2/features/order/presentation/bloc/order_bloc.dart';
import 'package:food_commerce_v2/features/order/presentation/pages/order_details_page.dart';
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
    _fetchOrders();
  }

  void _fetchOrders() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrderBloc>().add(FetchOrderHistory(userId: authState.user.id));
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'preparing':
        return Colors.orange;
      case 'on_the_way':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("My Orders"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainWrapperPage())),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Ongoing"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _fetchOrders, child: const Text("Retry")),
                  ],
                ),
              );
            }

            if (state is OrderHistoryLoaded) {
              final orders = state.orders ?? [];

              final ongoingOrders = orders
                  .where((o) => o.status.toLowerCase() != 'completed' && o.status.toLowerCase() != 'cancelled')
                  .toList();

              final completedOrders = orders.where((o) => o.status.toLowerCase() == 'completed').toList();

              return TabBarView(children: [_buildOrderList(ongoingOrders), _buildOrderList(completedOrders)]);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text("No orders found", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final dateStr = DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt);

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order #${order.id}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${order.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _statusColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
