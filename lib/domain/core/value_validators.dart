import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/core/failures.dart';
import 'package:kt_dart/collection.dart';

/// helper methods that validate enitity against business cases
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  /// if regex matches input string return input else throw exception
  if (RegExp(emailRegex).hasMatch(input)) {
    /// push to union
    return right(input);
  }
  return left(ValueFailure.invalidEmail(failedValue: input));
}

/// simple password length validator
Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  }
  return left(ValueFailure.shortPassword(failedValue: input));
}

/// Notes Validators
Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  }
  return left(
      ValueFailure.exceedingLength(failedValue: input, maxLength: maxLength));
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  }
  return left(ValueFailure.empty(failedValue: input));
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (!input.contains('\n')) {
    return right(input);
  }
  return left(ValueFailure.multiline(failedValue: input));
}

// ktlist is an immutable list
Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLength<T>(
  KtList<T> input,
  int maxLength,
) {
  if (input.size <= maxLength) {
    return right(input);
  }
  return left(ValueFailure.listTooLong(failedValue: input, max: maxLength));
}
