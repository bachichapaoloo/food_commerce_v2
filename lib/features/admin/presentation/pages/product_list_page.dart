import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_event.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_state.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when page loads
    context.read<AdminBloc>().add(LoadAdminData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => context.go('/admin/products/add'))],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AdminLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: product.imageUrl.isNotEmpty ? NetworkImage(product.imageUrl) : null,
                    child: product.imageUrl.isEmpty ? const Icon(Icons.fastfood) : null,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.go('/admin/products/edit/${product.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, product.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (id is int) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("ID is int, expected string for Admin? Check models.")));
                // Fix ID type mismatch if happens
                // context.read<AdminBloc>().add(DeleteProduct(id.toString()));
                return;
              }
              context.read<AdminBloc>().add(DeleteProduct(id)); // ID is int in Entity??
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
