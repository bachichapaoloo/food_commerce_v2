// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';
import 'package:food_commerce_v2/features/menu/data/models/product_model.dart';

class OrderDetailModel {
  final int orderId;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String specialInstructions;
  final List<AddOnOption> options; // Changed from List<String> modifiers
  final String status;
  OrderDetailModel({
    required this.orderId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.specialInstructions,
    required this.options,
    required this.status,
  });

  OrderDetailModel copyWith({
    int? orderId,
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? specialInstructions,
    List<AddOnOption>? options,
    String? status,
  }) {
    return OrderDetailModel(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      options: options ?? this.options,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'options': options.map((x) => {'id': x.id, 'name': x.name, 'price_modifier': x.priceModifier}).toList(),
      'status': status,
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      orderId: map['order_id'] as int,
      productId: map['product_id'].toString(),
      name: map['name'] ?? '',
      price: (map['price_at_purchase'] as num).toDouble(),
      quantity: map['qty'] as int,
      specialInstructions: map['special_instructions'] ?? '',
      options: map['options'] != null ? (map['options'] as List).map((x) => AddOnOptionModel.fromMap(x)).toList() : [],
      status: map['status'] ?? 'pending',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
