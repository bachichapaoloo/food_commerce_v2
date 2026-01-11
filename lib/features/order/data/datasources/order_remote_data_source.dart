import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../models/order_model.dart'; // You need to create this model extending OrderEntity!

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(String userId, List<CartItemEntity> items, double total);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient supabaseClient;

  OrderRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<OrderModel> placeOrder(String userId, List<CartItemEntity> items, double total) async {
    try {
      // 1. Insert Order and Get ID
      final orderData = await supabaseClient
          .from('orders')
          .insert({'user_id': userId, 'total_price': total, 'status': 'pending'})
          .select()
          .single(); // .single() returns the inserted row immediately

      final orderId = orderData['id'] as int;

      // 2. Prepare Order Items
      // We map the CartItems into a list of Maps for Supabase
      final List<Map<String, dynamic>> orderItemsData = items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.product.id,
          'quantity': item.quantity,
          'price': item.product.price,
        };
      }).toList();

      // 3. Insert All Items (Batch Insert)
      await supabaseClient.from('order_items').insert(orderItemsData);

      // 4. Return the Order Model
      return OrderModel.fromJson(orderData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
