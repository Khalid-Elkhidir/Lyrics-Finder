import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository}) : super(AuthInitial());
  final AuthRepository authRepository;

  bool authNeed() {
    bool need = true;
    final result = authRepository.accessTokenCheck();
    result.fold((failure) {
      emit(AuthError(message: "You need to sign up first"));
    }, (success) {
      if (success) {
        need =  false;
      } else {
        need =  true;
      }
    });
    return need;
  }

  void launchUrl() async {
    final result = await authRepository.launchUrl();
    result.fold(
        (failure) => emit(AuthError(message: "Check your internet connection")),
        (success) => null);
  }

  void initUniLinks() {
    final result = authRepository.initAppLink();
    result.fold(
      (failure) => emit(AuthError(message: "Sign up again")),
      (success) => null,
    );
  }

  StreamSubscription? subscription() {
    return authRepository.subscription();
  }
}
