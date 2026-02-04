import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
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
    Logger().i("AdminRemoteDataSource: getProducts called");
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
          .eq('is_active', true);
      Logger().i("AdminRemoteDataSource: getProducts success, count: ${(response as List).length}");

      return (response as List)
          .map((json) {
            try {
              return ProductModel.fromJson(json);
            } catch (e) {
              Logger().i("AdminRemoteDataSource: PARSING ERROR for product ID ${json['id']}: $e");
              Logger().i("AdminRemoteDataSource: PARSING ERROR for product ID ${json['id']}: $e");
              return null;
            }
          })
          .whereType<ProductModel>()
          .toList(); // Filter out failed items
    } catch (e, stacktrace) {
      Logger().i("AdminRemoteDataSource: CRITICAL ERROR getProducts: $e");
      Logger().i(stacktrace);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    Logger().i("AdminRemoteDataSource: getProductById called for $id");
    try {
      final response = await supabaseClient
          .from('products')
          .select('*, product_addons(*, addon_groups(*, addon_options(*)))')
          .eq('id', id)
          .single();
      Logger().i("AdminRemoteDataSource: getProductById success");
      return ProductModel.fromJson(response);
    } catch (e) {
      Logger().i("AdminRemoteDataSource: getProductById error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> createProduct(ProductModel product) async {
    Logger().i("AdminRemoteDataSource: createProduct called for ${product.name}");
    try {
      final productData = product.toJson();
      productData.remove('id');
      productData.remove('add_on_groups');
      Logger().i("AdminRemoteDataSource: Inserting product data: $productData");

      final res = await supabaseClient.from('products').insert(productData).select().single();
      final newProductId = res['id'].toString();
      Logger().i("AdminRemoteDataSource: Product inserted, ID: $newProductId");

      if (product.addOnGroups.isNotEmpty) {
        // Deduplicate groups
        final uniqueGroupIds = product.addOnGroups.map((g) => g.id).toSet();
        Logger().i("AdminRemoteDataSource: Linking ${uniqueGroupIds.length} add-on groups");

        final links = uniqueGroupIds.map((gid) => {'product_id': newProductId, 'addon_group_id': gid}).toList();
        await supabaseClient.from('product_addons').insert(links);
      }
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: createProduct error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateProduct(ProductModel product) async {
    Logger().i("AdminRemoteDataSource: updateProduct called for ${product.id}");
    try {
      final productData = product.toJson();
      productData.remove('add_on_groups');
      productData.remove('id');
      Logger().i("AdminRemoteDataSource: Updating product data: $productData");

      await supabaseClient.from('products').update(productData).eq('id', product.id);

      if (product.addOnGroups.isNotEmpty) {
        // Deduplicate groups to prevent PK violation within the batch
        final uniqueGroupIds = product.addOnGroups.map((g) => g.id).toSet();
        Logger().i("AdminRemoteDataSource: Replacing links for groups: $uniqueGroupIds");

        // 1. Delete existing links to ensure we don't duplicate or keep removed groups
        await supabaseClient.from('product_addons').delete().eq('product_id', product.id);

        // 2. Insert new links
        final links = uniqueGroupIds.map((gid) => {'product_id': product.id, 'addon_group_id': gid}).toList();
        await supabaseClient.from('product_addons').insert(links);
      } else {
        // If list is empty, we should still clear existing links
        await supabaseClient.from('product_addons').delete().eq('product_id', product.id);
      }
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: updateProduct error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> deleteProduct(String id) async {
    Logger().i("AdminRemoteDataSource: deleteProduct called for $id");
    try {
      // Soft delete: Update is_active to false
      await supabaseClient.from('products').update({'is_active': false}).eq('id', id);
      Logger().i("AdminRemoteDataSource: deleteProduct (soft) success");
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: deleteProduct error: $e");
      if (e.toString().contains("23503")) {
        throw ServerException("Cannot delete this product because it is part of existing orders.");
      }
      throw ServerException("Failed to delete product. Database error.");
    }
  }

  @override
  Future<List<AddOnGroupModel>> getAddOnGroups() async {
    Logger().i("AdminRemoteDataSource: getAddOnGroups called");
    try {
      final response = await supabaseClient.from('addon_groups').select('*, addon_options(*)');
      Logger().i(
        "AdminRemoteDataSource: getAddOnGroups response (first item): ${response.isNotEmpty ? response.first : 'EMPTY'}",
      );
      Logger().i("AdminRemoteDataSource: getAddOnGroups success, count: ${(response as List).length}");
      return (response as List).map((e) => AddOnGroupModel.fromMap(e)).toList();
    } catch (e) {
      Logger().i("AdminRemoteDataSource: getAddOnGroups error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> createAddOnGroup(AddOnGroupModel group) async {
    Logger().i("AdminRemoteDataSource: createAddOnGroup called for ${group.name}");
    try {
      final groupData = group.toMap();
      groupData.remove('id');
      groupData.remove('options');
      Logger().i("AdminRemoteDataSource: Inserting group data: $groupData");

      final res = await supabaseClient.from('addon_groups').insert(groupData).select().single();
      final groupId = res['id'].toString();
      Logger().i("AdminRemoteDataSource: Group inserted, ID: $groupId");

      if (group.options.isNotEmpty) {
        Logger().i("AdminRemoteDataSource: Inserting ${group.options.length} options");
        final optionsData = group.options.map((o) {
          return {'group_id': groupId, 'name': o.name, 'price_modifier': o.priceModifier};
        }).toList();
        await supabaseClient.from('addon_options').insert(optionsData);
      }
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: createAddOnGroup error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateAddOnGroup(AddOnGroupModel group) async {
    Logger().i("AdminRemoteDataSource: updateAddOnGroup called for ${group.id}");
    try {
      final groupData = group.toMap();
      groupData.remove('options');
      Logger().i("AdminRemoteDataSource: Updating group data: $groupData");

      await supabaseClient.from('addon_groups').update(groupData).eq('id', group.id);

      if (group.options.isNotEmpty) {
        Logger().i("AdminRemoteDataSource: Inserting new options: ${group.options.length}");
        final optionsData = group.options.map((o) {
          return {'group_id': group.id, 'name': o.name, 'price_modifier': o.priceModifier};
        }).toList();
        await supabaseClient.from('addon_options').insert(optionsData);
      }
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: updateAddOnGroup error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> deleteAddOnGroup(String id) async {
    Logger().i("AdminRemoteDataSource: deleteAddOnGroup called for $id");
    try {
      await supabaseClient.from('addon_groups').delete().eq('id', id);
      Logger().i("AdminRemoteDataSource: deleteAddOnGroup success");
      return unit;
    } catch (e) {
      Logger().i("AdminRemoteDataSource: deleteAddOnGroup error: $e");
      throw ServerException(e.toString());
    }
  }
}
