import 'package:flutter/material.dart';
import 'package:food_commerce_v2/features/auth/domain/entities/user_entity.dart';

class AuthenticatedView extends StatelessWidget {
  final UserEntity user;

  const AuthenticatedView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome, ${user.username}!", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          const Text("You are now authenticated."),
        ],
      ),
    );
  }
}
