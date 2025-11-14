import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.unauthenticated());

  void login(String email, String name) {
    emit(AuthState.authenticated(email, name));
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }
}

class AuthState {
  final bool isAuthenticated;
  final String? userEmail;
  final String? userName;
  final String? error;

  const AuthState._({
    required this.isAuthenticated,
    this.userEmail,
    this.userName,
    this.error,
  });

  const AuthState.unauthenticated() : this._(isAuthenticated: false);

  const AuthState.authenticated(String email, String name)
      : this._(isAuthenticated: true, userEmail: email, userName: name);

  const AuthState.error(String errorMessage)
      : this._(isAuthenticated: false, error: errorMessage);
}