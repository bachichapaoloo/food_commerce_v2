import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_commerce_v2/core/error/exceptions.dart';
import 'package:food_commerce_v2/features/menu/data/models/product_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<Unit> createProduct(ProductModel product);
  Future<Unit> updateProduct(ProductModel product);
  Future<Unit> deleteProduct(String id);

  Future<List<AddOnGroupModel>> getAddOnGroups();
  Future<Unit> createAddOnGroup(AddOnGroupModel group);
  Future<Unit> updateAddOnGroup(AddOnGroupModel group);
  Future<Unit> deleteAddOnGroup(String id);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdminRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await supabaseClient.from('products').select('''
        *,
        product_addons (
          addon_groups (
            *,
            addon_options (*)
          )
        )
      ''');

      return (response as List).map((json) {
        return ProductModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select('''
        *,
        product_addons (
          addon_groups (
            *,
            addon_options (*)
          )
        )
      ''')
          .eq('id', id)
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> createProduct(ProductModel product) async {
    try {
      final productData = product.toJson();
      productData.remove('id');
      productData.remove('add_on_groups');
      final res = await supabaseClient.from('products').insert(productData).select().single();
      final newProductId = res['id'].toString(); // Ensure String

      if (product.addOnGroups.isNotEmpty) {
        final links = product.addOnGroups
            .map((group) => {'product_id': newProductId, 'addon_group_id': group.id})
            .toList();
        await supabaseClient.from('product_addons').insert(links);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateProduct(ProductModel product) async {
    try {
      final productData = product.toJson();
      productData.remove('add_on_groups');

      await supabaseClient.from('products').update(productData).eq('id', product.id);

      await supabaseClient.from('product_addons').delete().eq('product_id', product.id);

      if (product.addOnGroups.isNotEmpty) {
        final links = product.addOnGroups
            .map((group) => {'product_id': product.id, 'addon_group_id': group.id})
            .toList();
        await supabaseClient.from('product_addons').insert(links);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> deleteProduct(String id) async {
    try {
      await supabaseClient.from('products').delete().eq('id', id);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AddOnGroupModel>> getAddOnGroups() async {
    try {
      final response = await supabaseClient.from('addon_groups').select('*, addon_options(*)');
      return (response as List).map((e) => AddOnGroupModel.fromMap(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> createAddOnGroup(AddOnGroupModel group) async {
    try {
      final groupData = group.toMap();
      groupData.remove('id');
      groupData.remove('options');

      final res = await supabaseClient.from('addon_groups').insert(groupData).select().single();
      final groupId = res['id'].toString();

      if (group.options.isNotEmpty) {
        final optionsData = group.options.map((o) {
          final m = (o as AddOnOptionModel).toMap();
          m.remove('id');
          m['group_id'] = groupId;
          return m;
        }).toList();
        await supabaseClient.from('addon_options').insert(optionsData);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateAddOnGroup(AddOnGroupModel group) async {
    try {
      final groupData = group.toMap();
      groupData.remove('options');

      await supabaseClient.from('addon_groups').update(groupData).eq('id', group.id);

      await supabaseClient.from('addon_options').delete().eq('group_id', group.id);

      if (group.options.isNotEmpty) {
        final optionsData = group.options.map((o) {
          final m = (o as AddOnOptionModel).toMap();
          m.remove('id');
          m['group_id'] = group.id;
          return m;
        }).toList();
        await supabaseClient.from('addon_options').insert(optionsData);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> deleteAddOnGroup(String id) async {
    try {
      await supabaseClient.from('addon_groups').delete().eq('id', id);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
