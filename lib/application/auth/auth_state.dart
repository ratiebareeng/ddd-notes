part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated() = Authenticated;
  const factory AuthState.unAuthenticated() = _Unauthenticated;

  /// TODO: Check if this doesn't break the code
}
