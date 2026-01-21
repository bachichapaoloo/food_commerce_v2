import 'package:food_commerce_v2/features/auth/domain/usecases/get_current_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/logout_user.dart';
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
  sl.registerFactory(() => AuthBloc(loginUser: sl(), registerUser: sl(), getCurrentUser: sl(), logoutUser: sl()));

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

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerLazySingleton(() => Supabase.instance.client);
}
