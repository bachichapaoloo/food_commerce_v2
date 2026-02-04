import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/features/menu/domain/enitities/add_on_option.dart';

class AddOnGroup extends Equatable {
  final String id;
  final String name;
  final int minSelection;
  final int maxSelection;
  final List<AddOnOption> options;

  const AddOnGroup({
    required this.id,
    required this.name,
    required this.minSelection,
    required this.maxSelection,
    required this.options,
  });

  bool get isRequired => minSelection > 0;
  bool get isMultiSelect => maxSelection > 1;

  @override
  List<Object?> get props => [id, name, minSelection, maxSelection, options];
}
