import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/core/value_objects.dart';

import '../core/failures.dart';
import '../core/value_validators.dart';

/// validated entity classes that don't allow unrepresentable states
class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// factory constructor that validates value
  factory EmailAddress(String? input) {
    assert(input != null);
    return EmailAddress._(validateEmailAddress(input!));
  }

  /// private default constructor
  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// factory constructor that validates value
  factory Password(String? input) {
    assert(input != null);
    return Password._(validatePassword(input!));
  }

  /// private default constructor
  const Password._(this.value);
}
