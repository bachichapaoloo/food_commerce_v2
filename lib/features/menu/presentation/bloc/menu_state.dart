import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

sealed class MenuState extends Equatable {
  const MenuState();
  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

// We merge Loading and Loaded.
// This allows us to show the "Categories" even while "Products" are fetching.
class MenuLoaded extends MenuState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final CategoryEntity? selectedCategory; // null = "All"
  final bool isLoading; // New field for partial loading
  final String? error; // New field for snackbars

  const MenuLoaded({
    this.categories = const [],
    this.products = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  // The Superpower Method
  MenuLoaded copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    CategoryEntity? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return MenuLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      // If we pass null explicitly, we want to keep it null.
      // This is a simple implementation; strict null handling requires more care,
      // but this works for your logic:
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Error usually resets on new actions, so we don't keep 'this.error'
    );
  }

  // Helper to safely clear selection (Go back to "All")
  MenuLoaded copyWithClearedSelection() {
    return MenuLoaded(
      categories: categories,
      products: products,
      selectedCategory: null,
      isLoading: isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, products, selectedCategory, isLoading, error];
}
