import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_menu.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetCategories getCategories;
  final GetProducts getProducts;

  MenuBloc({required this.getCategories, required this.getProducts}) : super(MenuInitial()) {
    on<MenuFetchStarted>(_onFetchStarted);
    on<MenuCategorySelected>(_onCategorySelected);
  }

  Future<void> _onFetchStarted(MenuFetchStarted event, Emitter<MenuState> emit) async {
    // Initial Full Load
    emit(const MenuLoaded(isLoading: true));

    // 1. Fetch Categories
    final categoriesResult = await getCategories(NoParams());

    await categoriesResult.fold((failure) async => emit(MenuLoaded(error: failure.message)), (categories) async {
      // 2. Fetch Initial Products (All)
      final productsResult = await getProducts(null);

      productsResult.fold(
        (failure) => emit(MenuLoaded(categories: categories, error: failure.message)),
        (products) => emit(
          MenuLoaded(
            categories: categories,
            products: products,
            selectedCategory: null, // Default to "All"
            isLoading: false,
          ),
        ),
      );
    });
  }

  Future<void> _onCategorySelected(MenuCategorySelected event, Emitter<MenuState> emit) async {
    final currentState = state;
    if (currentState is! MenuLoaded) return;

    // 1. Show Spinner (but keep categories visible!)
    emit(
      currentState.copyWith(
        isLoading: true,
        selectedCategory: event.category, // Optimistically update the tab highlight
      ),
    );

    // 2. Fetch new data
    // If category is null, we fetch all. If not, fetch by ID.
    final result = await getProducts(event.category?.id);

    // 3. Update list or show error
    result.fold(
      (failure) => emit(currentState.copyWith(isLoading: false, error: failure.message)),
      (newProducts) => emit(
        currentState.copyWith(
          isLoading: false,
          products: newProducts,
          // selectedCategory is already set in step 1
        ),
      ),
    );
  }
}
