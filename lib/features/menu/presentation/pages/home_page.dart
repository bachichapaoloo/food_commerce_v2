import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/pages/login_page.dart';
import 'package:food_commerce_v2/features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../../../../injection_container.dart'; // To access 'sl'
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap the whole view in the MenuBloc Provider
    return BlocProvider(create: (context) => sl<MenuBloc>()..add(MenuFetchStarted()), child: const _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    // Access User Data (Safe because we are already authenticated)
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user.username}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      // 2. Listen to Auth Changes (Logout)
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
          }
        },
        // 3. Consume Menu Data
        child: BlocConsumer<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state is MenuLoaded && state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            // HANDLE INITIAL STATE
            if (state is MenuInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // HANDLE LOADED STATE (Our new powerful state)
            if (state is MenuLoaded) {
              return Column(
                children: [
                  // A. Category Selector (Horizontal List)
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final isSelected = state.selectedCategory == category;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(category.name),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              // If unselected, pass null (which means "All")
                              final categoryToSelect = selected ? category : null;
                              context.read<MenuBloc>().add(MenuCategorySelected(categoryToSelect));
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // B. Loading Indicator (Overlay or Linear Progress)
                  if (state.isLoading) const LinearProgressIndicator(),

                  // C. Product List
                  Expanded(
                    child: state.products.isEmpty
                        ? const Center(child: Text("No products found."))
                        : ListView.builder(
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return ListTile(
                                leading: Image.network(
                                  product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                                ),
                                title: Text(product.name),
                                subtitle: Text("\$${product.price}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  onPressed: () {
                                    context.read<CartBloc>().add(AddItemToCart(product));

                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${product.name} added to cart!"),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              // We will build the CartPage next!
              print("Go to Cart");
            },
            label: Text("${state.totalItems} Items - \$${state.totalBill.toStringAsFixed(2)}"),
            icon: const Icon(Icons.shopping_basket),
          );
        },
      ),
    );
  }
}
