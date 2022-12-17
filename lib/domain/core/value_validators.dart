import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/core/failures.dart';

/// helper methods that validate enitity against business cases
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  /// if regex matches input string return input else throw exception
  if (RegExp(emailRegex).hasMatch(input)) {
    /// push to union
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

/// simple password length validator
Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure.shortPassword(failedValue: input));
  }
}
