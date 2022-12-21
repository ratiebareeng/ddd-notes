import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../auth/value_objects.dart';

part 'failures.freezed.dart';

/// value failure
/// the class is generic because we will also validate values other than Strings
/// union class that groups all failures from validated value objects
@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  /// union case for invalid email
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;

  /// union case for short password
  const factory ValueFailure.shortPassword({required T failedValue}) =
      ShortPassword<T>;

  /// Notes failures
  const factory ValueFailure.exceedingLength({
    required T failedValue,
    required int maxLength,
  }) = ExceedingLength<T>;
  // note body or todo body cannot be empty
  const factory ValueFailure.empty({required T failedValue}) = Empty<T>;
  // todo body cannot be multiline
  const factory ValueFailure.multiline({required T failedValue}) = Multiline<T>;
  //  list too long failure > 3 todos
  const factory ValueFailure.listTooLong({
    required T failedValue,
    required int max,
  }) = ListTooLong<T>;
}

/// implementation
void showEmailAddressOrFailure() {
  final emailAddress = EmailAddress('invalid');

  /// gives you access to the failure type
  String emailText = emailAddress.value.fold(
    (left) => 'Failure occured: $left',
    (right) => right,
  );
  log(emailText);

  /// shorthand: doesn't tell you precisely what failure occurred
  /// because we don't have access to it
  String emailTextShortHand = emailAddress.value.getOrElse(
    () => 'Failure Occurred',
  );
  log(emailTextShortHand);
}
