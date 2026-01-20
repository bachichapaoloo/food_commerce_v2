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
      orderId: map['orderId'] as int,
      productId: map['productId'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      specialInstructions: map['specialInstructions'] as String,
      modifiers: List<String>.from((map['modifiers'] as List<String>)),
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderDetailModel(orderId: $orderId, productId: $productId, name: $name, price: $price, quantity: $quantity, specialInstructions: $specialInstructions, modifiers: $modifiers, status: $status)';
  }

  @override
  bool operator ==(covariant OrderDetailModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.productId == productId &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.specialInstructions == specialInstructions &&
        listEquals(other.modifiers, modifiers) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        productId.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        specialInstructions.hashCode ^
        modifiers.hashCode ^
        status.hashCode;
  }
}
