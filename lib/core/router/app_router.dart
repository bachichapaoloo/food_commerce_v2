import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_commerce_v2/features/navigation/main_wrapper_page.dart';
import 'package:food_commerce_v2/features/auth/presentation/pages/login_page.dart';
import 'package:food_commerce_v2/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:food_commerce_v2/features/admin/presentation/pages/product_list_page.dart';
import 'package:food_commerce_v2/features/admin/presentation/pages/add_edit_product_page.dart';
import 'package:food_commerce_v2/features/admin/presentation/pages/add_on_manager_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/admin', // Temporary: start at admin for development
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainWrapperPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardPage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductListPage(),
          routes: [
            GoRoute(path: 'add', builder: (context, state) => const AddEditProductPage()),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return AddEditProductPage(productId: id);
              },
            ),
          ],
        ),
        GoRoute(path: 'addons', builder: (context, state) => const AddOnManagerPage()),
      ],
    ),
  ],
);
