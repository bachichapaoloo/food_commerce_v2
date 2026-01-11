class OrderModel {
  final int id;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const OrderModel({required this.id, required this.totalPrice, required this.status, required this.createdAt});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'total_price': totalPrice, 'status': status, 'created_at': createdAt.toIso8601String()};
  }
}
