import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart'; // We need to create this file!
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailPassword(String email, String password);
  Future<UserModel> registerWithEmailPassword(String email, String password, String username);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw const ServerException('User is null after login');
      }

      return _getUserProfile(response.user!.id, response.user!.email!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmailPassword(String email, String password, String username) async {
    try {
      // 1. Sign Up in Auth System
      final response = await supabaseClient.auth.signUp(email: email, password: password);

      if (response.user == null) {
        throw const ServerException('Registration failed');
      }

      // 2. Create Profile Entry in Database
      // Note: In production, a Postgres Trigger is safer, but this is fine for now.
      await supabaseClient.from('profiles').insert({'id': response.user!.id, 'username': username, 'email': email});

      return UserModel(id: response.user!.id, email: email, username: username, avatarUrl: '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;
    return _getUserProfile(user.id, user.email ?? '');
  }

  // Helper to fetch extra profile data
  Future<UserModel> _getUserProfile(String userId, String email) async {
    try {
      final data = await supabaseClient.from('profiles').select().eq('id', userId).single();

      return UserModel(
        id: userId,
        email: email,
        username: data['username'] ?? 'User',
        avatarUrl: data['avatar_url'] ?? '',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      // 1. Trigger the sign-in flow
      // This will open the default browser (Chrome/Safari/Edge)
      final result = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,

        // CRITICAL: This MUST match exactly what you set in:
        // 1. AndroidManifest.xml (data android:scheme="io.foodcommerce.app" ...)
        // 2. Info.plist (CFBundleURLSchemes)
        // 3. Supabase Dashboard (Redirect URLs)
        redirectTo: 'io.foodcommerce.app://login-callback',
      );

      // 2. Return success
      // Note: This just means "Browser launched successfully".
      // The actual login happens when the user clicks "Yes" in the browser
      // and the browser redirects back to the app.
      return result;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
