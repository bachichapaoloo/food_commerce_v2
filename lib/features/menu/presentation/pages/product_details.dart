import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/enitities/product_entity.dart';
import '../../data/models/product_model.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  // Key: GroupID, Value: Set of selected Options
  final Map<String, Set<AddOnOptionModel>> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Initialize empty sets for each group to avoid null checks later
    for (var group in widget.product.addOnGroups) {
      _selectedOptions[group.id] = {};
    }
  }

  // Calculate total price dynamically
  double get _totalPrice {
    double addonTotal = 0;
    _selectedOptions.forEach((key, options) {
      for (var option in options) {
        addonTotal += option.priceModifier;
      }
    });
    return (widget.product.price + addonTotal) * quantity;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. HERO IMAGE HEADER
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              // Favorite Button
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    // TODO: Implement Wishlist Feature
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[200], child: const Icon(Icons.fastfood, size: 50)),
                  ),
                  // Gradient for text readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. MAIN CONTENT
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "\$${widget.product.price}",
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Social Proof (Rating, Time, Calories)
                  Row(
                    children: [
                      _buildIconText(Icons.star, "4.8", Colors.orange),
                      const SizedBox(width: 16),
                      _buildIconText(Icons.access_time, "15-20 min", Colors.blue),
                      const SizedBox(width: 16),
                      _buildIconText(Icons.local_fire_department, "350 kcal", Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    widget.product.description.isEmpty
                        ? "A culinary masterpiece prepared with the finest ingredients to satisfy your cravings."
                        : widget.product.description,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  // 3. ADD-ONS SECTION (Dynamic)
                  if (widget.product.addOnGroups.isNotEmpty) ...[
                    const Text("Customize your Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...widget.product.addOnGroups.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "${group.name} ${group.maxSelection > 1 ? '(Choose up to ${group.maxSelection})' : '(Choose 1)'}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          ...group.options.map((option) {
                            final modelOption = option as AddOnOptionModel; // Cast for now as we know logic uses models
                            final isSelected = _selectedOptions[group.id]?.contains(modelOption) ?? false;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected ? Colors.green.withOpacity(0.05) : Colors.white,
                              ),
                              child: group.maxSelection == 1
                                  ? RadioListTile<AddOnOptionModel>(
                                      activeColor: Colors.green,
                                      title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                      secondary: Text(
                                        option.priceModifier > 0
                                            ? "+\$${option.priceModifier.toStringAsFixed(2)}"
                                            : "Free",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      value: modelOption,
                                      groupValue: _selectedOptions[group.id]?.isNotEmpty == true
                                          ? _selectedOptions[group.id]!.first
                                          : null,
                                      onChanged: (AddOnOptionModel? value) {
                                        setState(() {
                                          _selectedOptions[group.id]!.clear(); // Radio: clear others
                                          if (value != null) {
                                            _selectedOptions[group.id]!.add(value);
                                          }
                                        });
                                      },
                                    )
                                  : CheckboxListTile(
                                      activeColor: Colors.green,
                                      title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                      secondary: Text(
                                        option.priceModifier > 0
                                            ? "+\$${option.priceModifier.toStringAsFixed(2)}"
                                            : "Free",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            // Optional: Enforce max selection limit for checkboxes
                                            if (_selectedOptions[group.id]!.length < group.maxSelection) {
                                              _selectedOptions[group.id]!.add(modelOption);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Max ${group.maxSelection} selection allowed.")),
                                              );
                                            }
                                          } else {
                                            _selectedOptions[group.id]!.remove(modelOption);
                                          }
                                        });
                                      },
                                    ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ],

                  const SizedBox(height: 24),

                  // 4. SPECIAL INSTRUCTIONS
                  const Text("Special Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "E.g. No onions, sauce on the side...",
                      fillColor: Colors.grey.shade50,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),

      // 5. STICKY BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Counter
              Container(
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                    ),
                    Text(quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(icon: const Icon(Icons.add, size: 20), onPressed: () => setState(() => quantity++)),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _addToCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add  \$${_totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Icon+Text rows
  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _addToCart() {
    // IMPORTANT:
    // Currently, your CartItemEntity might not support 'modifiers' or 'notes'.
    // For now, we just add the base product x quantity.
    // In "Phase 3: Advanced Cart", we will update the Cart Logic to store these notes.

    // Flatten Logic: Create a new product entity with modified name and price
    String customizedName = widget.product.name;
    double additionalPrice = 0;
    List<String> selectedNames = [];

    _selectedOptions.forEach((key, options) {
      for (var option in options) {
        selectedNames.add(option.name);
        additionalPrice += option.priceModifier;
      }
    });

    if (selectedNames.isNotEmpty) {
      customizedName += " (${selectedNames.join(', ')})";
    }

    final customizedProduct = ProductEntity(
      id: widget
          .product
          .id, // Keep ID for reference, though strictly this might merge cart items incorrectly if not handled. For V1 is ok.
      name: customizedName,
      description: _notesController.text.isNotEmpty ? "Note: ${_notesController.text}" : widget.product.description,
      price: widget.product.price + additionalPrice,
      imageUrl: widget.product.imageUrl,
      categoryId: widget.product.categoryId,
      addOnGroups: widget.product.addOnGroups, // Keep original structure
    );

    // We loop to support the quantity
    for (int i = 0; i < quantity; i++) {
      context.read<CartBloc>().add(AddItemToCart(customizedProduct));
    }

    Navigator.pop(context);

    // Enhanced Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text("Added ${widget.product.name} to cart"),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to Cart
          },
        ),
      ),
    );
  }
}
