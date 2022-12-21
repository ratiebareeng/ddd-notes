import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/auth/user.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// ensures bloc is given data it needs
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;
  AuthBloc(this._authFacade) : super(const _Initial()) {
    on<AuthEvent>((event, emit) {
      event.map(
        started: (e) {
          emit(const AuthState.initial());
        },

        /// check whether user is signed in
        authCheckRequested: (e) {
          /// 1. call auth facade method to get signed in user
          Option<AppUser> userOption = _authFacade.getSignedInUser();
          userOption.fold(
            () => emit(const AuthState.unAuthenticated()), // !user_found
            (_) => emit(const AuthState.authenticated()), // user found
          );
        },
        signedOut: (e) {
          _authFacade.signOut();
          emit(const AuthState.unAuthenticated());
        },
      );
    });
  }
}
