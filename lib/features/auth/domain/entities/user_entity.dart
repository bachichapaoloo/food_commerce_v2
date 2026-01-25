import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  String? avatarUrl;

  UserEntity({required this.id, required this.email, required this.username, this.avatarUrl});

  @override
  List<Object?> get props => [id, email, username, avatarUrl];
}
