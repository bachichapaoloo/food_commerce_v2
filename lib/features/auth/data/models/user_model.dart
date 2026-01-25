import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, required super.username, required super.avatarUrl});

  // Factory to create a UserModel from Supabase data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      // If we fetch from the 'profiles' table, the key is 'username'
      // If we merge data manually, we handle it here.
      username: json['username'] ?? 'User',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  // Convert back to Map (useful for sending data to Supabase)
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'username': username, 'avatar_url': avatarUrl};
  }
}
