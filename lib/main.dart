import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:food_commerce_v2/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:food_commerce_v2/features/navigation/main_wrapper_page.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart'; // We will create this next

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize GetIt
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()),
        BlocProvider(create: (_) => di.sl<MenuBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Commerce V2',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), useMaterial3: true),
      home: const LoginPage(),
    );
  }
}
