import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_commerce_v2/core/error/failure.dart';
import 'package:food_commerce_v2/core/usecases/usecase.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/get_current_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/logout_user.dart';
import 'package:food_commerce_v2/features/auth/domain/usecases/sign_in_with_google.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
// Import other usecases...

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser; // You will need to create this UseCase later
  final GetCurrentUser _getCurrentUser; // You will need to create this UseCase later
  final SignInWithGoogle _signInWithGoogle;

  AuthBloc({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
    required SignInWithGoogle signInWithGoogle,
  }) : _loginUser = loginUser,
       _registerUser = registerUser,
       _getCurrentUser = getCurrentUser,
       _logoutUser = logoutUser,
       _signInWithGoogle = signInWithGoogle,
       super(AuthInitial()) {
    // handle login event
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await _loginUser(LoginUserParams(email: event.email, password: event.password));

      // The 'fold' method comes from Dartz.
      // Left = Failure, Right = Success
      result.fold((failure) => emit(AuthError(failure.message)), (user) => emit(AuthAuthenticated(user)));
    });

    // handle register event
    on<AuthRegisterRequested>((event, emit) async {
      // TODO: IMPLEMENT THIS YOURSELF
      // 1. Emit Loading
      emit(AuthLoading());

      // 2. Call _registerUser
      final result = await _registerUser(
        RegisterUserParams(username: event.username, email: event.email, password: event.password),
      );

      // 3. Fold the result (Error -> AuthError, Success -> AuthAuthenticated)
      result.fold((failure) => emit(AuthError(failure.message)), (user) => emit(AuthAuthenticated(user)));
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await _logoutUser();

      result.fold((failure) => emit(AuthError(failure.message)), (_) => emit(AuthUnauthenticated()));
    });

    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await _getCurrentUser();

      result.fold((_) => emit(AuthUnauthenticated()), (user) => emit(AuthAuthenticated(user)));
    });

    on<AuthSignInGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithGoogle(NoParams());

      result.fold((failure) => emit(AuthFailure(failure)), (success) async {
        if (success) {
          // Assuming you want to fetch the current user after successful sign-in
          final userResult = await _getCurrentUser();
          userResult.fold((_) => emit(AuthUnauthenticated()), (user) => emit(AuthAuthenticated(user)));
        } else {
          emit(AuthUnauthenticated());
        }
      });
    });
  }
}
