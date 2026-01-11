import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const OrderEntity({required this.id, required this.totalPrice, required this.status, required this.createdAt});

  @override
  List<Object?> get props => [id, totalPrice, status, createdAt];
}
