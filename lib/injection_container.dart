import 'package:food_commerce_v2/features/auth/domain/usecases/get_current_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/logout_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:food_commerce_v2/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:food_commerce_v2/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:food_commerce_v2/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:food_commerce_v2/features/menu/domain/repositories/menu_repository.dart';
import 'package:food_commerce_v2/features/menu/domain/usecases/get_menu.dart';
import 'package:food_commerce_v2/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:food_commerce_v2/features/order/data/datasources/order_remote_data_source.dart';
import 'package:food_commerce_v2/features/order/data/repositories/order_repository_impl.dart';
import 'package:food_commerce_v2/features/order/domain/repositories/order_repository.dart';
import 'package:food_commerce_v2/features/order/domain/usecases/get_orders.dart';
import 'package:food_commerce_v2/features/order/domain/usecases/place_order.dart';
import 'package:food_commerce_v2/features/order/presentation/bloc/order_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:food_commerce_v2/features/admin/domain/repositories/admin_repository.dart';
import 'package:food_commerce_v2/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:food_commerce_v2/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/create_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/create_product.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/delete_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/delete_product.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/get_add_on_groups.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/get_admin_products.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/update_add_on_group.dart';
import 'package:food_commerce_v2/features/admin/domain/usecases/update_product.dart';

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/constants.dart'; // Create a file for your URL/Keys
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  await Supabase.initialize(
    url: AppConstants.supabaseUrl, // Uses the constant
    anonKey: AppConstants.supabaseAnonKey, // Uses the constant
  );

  // Bloc
  sl.registerFactory(
    () => AuthBloc(loginUser: sl(), registerUser: sl(), getCurrentUser: sl(), logoutUser: sl(), signInWithGoogle: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  // Feature - Menu
  sl.registerFactory(() => MenuBloc(getCategories: sl(), getProducts: sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSourceImpl(supabaseClient: sl()));

  // Feature - Cart
  sl.registerFactory(() => CartBloc());

  // Featuer - Order
  sl.registerFactory(() => OrderBloc(placeOrder: sl(), getOrders: sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(supabaseClient: sl()));

  // Feature - Admin
  sl.registerFactory(
    () => AdminBloc(
      getAdminProducts: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      getAddOnGroups: sl(),
      createAddOnGroup: sl(),
      updateAddOnGroup: sl(),
      deleteAddOnGroup: sl(),
    ),
  );
  // Admin Usecases
  sl.registerLazySingleton(() => GetAdminProducts(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => GetAddOnGroups(sl()));
  sl.registerLazySingleton(() => CreateAddOnGroupUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddOnGroupUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddOnGroupUseCase(sl()));

  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(supabaseClient: sl()));

  // Repository and authentication
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerLazySingleton(() => Supabase.instance.client);
}
