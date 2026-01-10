import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import '../../../../../core/constants/constants.dart'; // Ensure you have table names here

abstract class MenuRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({int? categoryId});
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final SupabaseClient supabaseClient;

  MenuRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await supabaseClient.from('categories').select();
      return (data as List).map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    try {
      var query = supabaseClient.from('products').select();

      if (categoryId != null) {
        // Only fetch items for this category
        query = query.eq('category_id', categoryId);
      }

      final data = await query;
      return (data as List).map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
