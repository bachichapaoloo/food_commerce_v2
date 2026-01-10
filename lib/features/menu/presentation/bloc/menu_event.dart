// ... imports

import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/product_entity.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
  @override
  List<Object?> get props => [];
}

class MenuFetchStarted extends MenuEvent {}

class MenuCategorySelected extends MenuEvent {
  final CategoryEntity? category; // Make nullable to allow selecting "All"

  const MenuCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}
