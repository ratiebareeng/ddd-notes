import 'package:freezed_annotation/freezed_annotation.dart';

/// auth failures
part 'auth_failure.freezed.dart';

/// case failures apply regardless of what auth backend we use
@freezed
abstract class AuthFailure with _$AuthFailure {
  /// user taps out of third party (ex. google) sign in flow screen
  const factory AuthFailure.cancelledByUser() = CancelledByUser;

  /// unspecified auth server error
  const factory AuthFailure.serverError() = ServerError;

  /// email already in use
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;

  /// wrong email and password combo
  const factory AuthFailure.invalidEmailAndPasswordCombination() =
      InvalidEmailAndPasswordCombination;
}
