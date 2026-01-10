import 'package:food_commerce_v2/features/auth/domain/usecases/get_current_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/logout_user.dart';
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

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerLazySingleton(() => Supabase.instance.client);
}
