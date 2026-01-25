import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_commerce_v2/features/menu/presentation/bloc/menu_event.dart';
import 'package:food_commerce_v2/features/menu/presentation/pages/product_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../menu/presentation/bloc/menu_bloc.dart';
import '../../menu/presentation/bloc/menu_state.dart';

class HomeLandingPage extends StatefulWidget {
  const HomeLandingPage({super.key});

  @override
  State<HomeLandingPage> createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {
  @override
  void initState() {
    super.initState();
    final menuBloc = context.read<MenuBloc>();
    if (menuBloc.state is MenuInitial) {
      menuBloc.add(MenuFetchStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    // Time-based greeting logic
    final hour = DateTime.now().hour;
    String greeting = "Good Morning ";
    if (hour > 11) greeting = "Good Afternoon ";
    if (hour > 17) greeting = "Good Evening ";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. THE APP BAR
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                "$greeting${user.username}!",
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                  Container(color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),

          // 2. THE SEARCH BAR (Non-functional visual)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for tacos, burgers...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // 3. PROMO CAROUSEL
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: PageView(
                controller: PageController(viewportFraction: 0.9),
                children: [
                  _buildPromoCard(Colors.orange, "Get 50% Off", "On your first order"),
                  _buildPromoCard(Colors.blue, "Free Delivery", "Order over \$20"),
                ],
              ),
            ),
          ),

          // 4. "POPULAR NOW" HEADER
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text("Popular Now 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),

          // 5. THE FOOD GRID (Dynamic from BLoC)
          BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              if (state is MenuLoaded) {
                final products = state.products.take(6).toList();

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("\$${product.price}", style: const TextStyle(color: Colors.green)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: products.length),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            },
          ),

          // Bottom padding so items aren't stuck behind nav bar
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Color color, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }
}
