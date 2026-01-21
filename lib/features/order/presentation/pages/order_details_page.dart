import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:food_commerce_v2/features/order/domain/entities/order_entity.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAF5),
        elevation: 0,
        title: const Text('Order Details', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER
            _buildHeader(formattedDate),

            const SizedBox(height: 24),

            /// ITEMS
            _buildItems(),

            const SizedBox(height: 24),

            /// SUMMARY
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // HEADER
  // ---------------------------
  Widget _buildHeader(String formattedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: order.status == 'completed' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(color: order.status == 'completed' ? Colors.green : Colors.amber, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          /// STATUS CHIP
          const SizedBox(height: 8),
          Text(formattedDate, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  // ---------------------------
  // ITEMS LIST
  // ---------------------------
  Widget _buildItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          ...order.items!.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// QUANTITY BOX
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// ITEM NAME
                  Expanded(
                    child: Text(item.product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),

                  /// SNAPSHOT PRICE
                  Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // SUMMARY
  // ---------------------------
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${order.totalPrice.toStringAsFixed(2)}'),
          _summaryRow('Delivery', '\$0.00'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _summaryRow('Total', '\$${order.totalPrice.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}
