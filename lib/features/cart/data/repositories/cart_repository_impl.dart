import 'package:dartz/dartz.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final SupabaseClient supabaseClient;

  CartRepositoryImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, void>> placeOrder({
    required String userId,
    required List<CartItemEntity> items,
    required double total,
  }) async {
    try {
      // 1. Insert Order Header
      final orderResponse = await supabaseClient
          .from('orders')
          .insert({'user_id': userId, 'total_price': total, 'status': 'pending'})
          .select()
          .single();

      final orderId = orderResponse['id'];

      // 2. Prepare Order Items
      final List<Map<String, dynamic>> orderItemsData = items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.product.id,
          'quantity': item.quantity,
          'price_at_time': item.product.price,
        };
      }).toList();

      // 3. Insert All Items
      await supabaseClient.from('order_items').insert(orderItemsData);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
