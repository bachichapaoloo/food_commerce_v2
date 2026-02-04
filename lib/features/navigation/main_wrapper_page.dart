import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/cart/presentation/bloc/cart_state.dart';
import 'package:food_commerce_v2/features/home/presentation/home_landing_page.dart';
import 'package:food_commerce_v2/features/menu/presentation/pages/menu_page.dart';
import '../cart/presentation/bloc/cart_bloc.dart';
import '../cart/presentation/pages/cart_page.dart';
import '../profile/presentation/pages/profile_page.dart';

class MainWrapperPage extends StatefulWidget {
  const MainWrapperPage({super.key});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  int _currentIndex = 0;

  // The list of pages to switch between
  final List<Widget> _pages = [const HomeLandingPage(), const MenuPage(), const CartPage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant_menu), // Filled icon
            label: 'Menu',
          ),
          // We can add a Badge to the Cart icon!
          NavigationDestination(
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.items.isEmpty) return const Icon(Icons.shopping_bag_outlined);
                return Badge(label: Text(state.totalItems.toString()), child: const Icon(Icons.shopping_bag_outlined));
              },
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
