part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthDone extends AuthState {
  String accessToken;

  AuthDone({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}

class AuthError extends AuthState {
  String message;

  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
