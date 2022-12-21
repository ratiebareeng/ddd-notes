part of 'auth_bloc.dart';

/// tells bloc what to do
/// checks auth status
/// signout user
/// bloc naming convetion: events should be named in the past tense
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = _Started;
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
  const factory AuthEvent.signedOut() = SignedOut;
}
