import 'package:equatable/equatable.dart';

class AddOnOption extends Equatable {
  final String id;
  final String name;
  final double priceModifier;

  const AddOnOption({required this.id, required this.name, this.priceModifier = 0.0});

  @override
  List<Object?> get props => [id, name, priceModifier];
}
