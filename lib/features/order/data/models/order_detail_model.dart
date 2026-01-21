// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderDetailModel {
  final int orderId;
  final int productId;
  final String name;
  final double price;
  final int quantity;
  final String specialInstructions;
  final List<String> modifiers;
  final String status;
  OrderDetailModel({
    required this.orderId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.specialInstructions,
    required this.modifiers,
    required this.status,
  });

  OrderDetailModel copyWith({
    int? orderId,
    int? productId,
    String? name,
    double? price,
    int? quantity,
    String? specialInstructions,
    List<String>? modifiers,
    String? status,
  }) {
    return OrderDetailModel(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      modifiers: modifiers ?? this.modifiers,
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
      'modifiers': modifiers,
      'status': status,
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      orderId: map['order_id'] as int, // snake_case from DB
      productId: map['product_id'] as int, // snake_case from DB
      name: map['name'] ?? '',
      price: (map['price_at_purchase'] as num).toDouble(), // DB column name
      quantity: map['qty'] as int, // or 'quantity' depending on your table
      specialInstructions: map['special_instructions'] ?? '',
      modifiers: [],
      status: map['status'] ?? 'pending',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
