import 'package:food_commerce_v2/features/order/data/models/order_detail_model.dart';

class OrderModel {
  final int id;
  final double totalPrice;
  List<OrderDetailModel>? items;
  final String status;
  final DateTime createdAt;

  OrderModel({required this.id, required this.totalPrice, this.items, required this.status, required this.createdAt});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      items: json['order_details'] != null
          ? (json['order_details'] as List).map((item) => OrderDetailModel.fromJson(item)).toList()
          : null,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'total_price': totalPrice, 'status': status, 'created_at': createdAt.toIso8601String()};
  }
}
