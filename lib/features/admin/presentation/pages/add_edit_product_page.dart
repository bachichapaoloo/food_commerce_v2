import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_event.dart';
import 'package:food_commerce_v2/features/admin/presentation/bloc/admin_state.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_group.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';
import 'package:go_router/go_router.dart';

class AddEditProductPage extends StatefulWidget {
  final String? productId;

  const AddEditProductPage({super.key, this.productId});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryIdController;

  final List<AddOnGroup> _selectedAddOns = [];

  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imageUrlController = TextEditingController();
    _categoryIdController = TextEditingController(text: '1'); // Default category ID
    // Check if we need to load data
    context.read<AdminBloc>().add(LoadAdminData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final state = context.watch<AdminBloc>().state;
      if (state is AdminLoaded && widget.productId != null) {
        final product = state.products.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => const ProductEntity(id: '', name: '', description: '', price: 0, imageUrl: '', categoryId: 0),
        );
        if (product.id.isNotEmpty) {
          _nameController.text = product.name;
          _descriptionController.text = product.description;
          _priceController.text = product.price.toString();
          _imageUrlController.text = product.imageUrl;
          _categoryIdController.text = product.categoryId.toString();
          _selectedAddOns.addAll(product.addOnGroups);
        }
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveProduct)],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          List<AddOnGroup> availableGroups = [];
          if (state is AdminLoaded) {
            availableGroups = state.addOnGroups;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _categoryIdController,
                        decoration: const InputDecoration(labelText: 'Category ID', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),
                const Text('Add-ons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Select which add-on groups apply to this product.'),
                if (availableGroups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "No Add-on Groups found. Go to 'Manage Add-on Groups' to create some.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ...availableGroups.map((group) {
                  final isSelected = _selectedAddOns.any((g) => g.id == group.id);
                  return CheckboxListTile(
                    title: Text(group.name),
                    subtitle: Text('${group.options.length} options'),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedAddOns.add(group);
                        } else {
                          _selectedAddOns.removeWhere((g) => g.id == group.id);
                        }
                      });
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = ProductEntity(
        id: widget.productId ?? '', // Empty for new, handled by Repo
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        imageUrl: _imageUrlController.text,
        categoryId: int.tryParse(_categoryIdController.text) ?? 1,
        addOnGroups: _selectedAddOns,
      );

      if (widget.productId != null && widget.productId!.isNotEmpty) {
        context.read<AdminBloc>().add(UpdateProduct(product));
      } else {
        context.read<AdminBloc>().add(CreateProduct(product));
      }
      context.pop();
    }
  }
}
