import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_commerce_v2/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We can assume user is logged in if they reached this page
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        children: [
          // Header
          UserAccountsDrawerHeader(
            accountName: Text(user.username),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(user.username[0].toUpperCase(), style: const TextStyle(fontSize: 40)),
            ),
            decoration: BoxDecoration(color: Colors.orange.shade400),
          ),

          // Options
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Order History"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Order History Page (Future Feature)
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text("Payment Methods"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Dispatch Logout Event
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}
