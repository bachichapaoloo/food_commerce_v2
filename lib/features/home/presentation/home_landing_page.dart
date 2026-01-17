import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/core/widgets/carousel_widget.dart';
import 'package:food_commerce_v2/core/widgets/square_button_widget.dart';
import 'package:food_commerce_v2/features/home/data/models/promo_banner_model.dart';
import '../../menu/presentation/bloc/menu_bloc.dart';
import '../../menu/presentation/bloc/menu_state.dart';
import '../../menu/presentation/bloc/menu_event.dart';

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Large Hero Banner
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836', // Replace with asset
                fit: BoxFit.cover,
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PromoCarousel(
                banners: [
                  PromoBanner(
                    imageUrl:
                        'https://images.unsplash.com/photo-1559847844-5315695dadae?q=80&w=1158&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Replace with asset later
                    title: 'Summer Specials',
                    subtitle: 'Up to 50% off on selected items!',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  PromoBanner(
                    imageUrl:
                        'https://images.unsplash.com/photo-1541832676-9b763b0239ab?q=80&w=1020&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Replace with asset later
                    title: 'Gourmet Delights',
                    subtitle: 'Explore our new gourmet menu.',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ),
          ),

          // Delivery or Pick Up Options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BigSquareButton(
                    title: 'Pickup',
                    size: 150,
                    icon: Icons.store,
                    onTap: () {
                      print('Pickup selected');
                    },
                    // isSelected: selectedType == 'pickup',
                    borderColor: Colors.green,
                  ),

                  BigSquareButton(
                    title: 'Dropoff',
                    size: 150,
                    icon: Icons.delivery_dining,
                    onTap: () {
                      print('Dropoff selected');
                    },
                    // isSelected: selectedType == 'dropoff',
                    borderColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // 2. "Popular Now" Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Popular Now 🔥", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),

          // 3. Horizontal List of Featured Items
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: BlocBuilder<MenuBloc, MenuState>(
                builder: (context, state) {
                  if (state is MenuLoaded) {
                    final featuredItems = state.products.take(10).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredItems.length,
                      itemBuilder: (context, index) {
                        final item = featuredItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageUrl,
                                    height: 120,
                                    width: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 80),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("\$${item.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Failed to load menu items."));
                  }
                },
              ),
            ),
          ),

          // 4. More sections (Categories, Deals, etc)...
        ],
      ),
    );
  }
}
