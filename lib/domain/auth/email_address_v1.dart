import 'dart:developer';

import 'package:equatable/equatable.dart';

class EmailAddressV1 extends Equatable {
  final String? value;

  /// factory constructor thar validates value
  factory EmailAddressV1(String? input) {
    assert(input != null);
    return EmailAddressV1._(validateEmailAddress(input!));
  }

  /// private default constructor
  const EmailAddressV1._(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() {
    return 'EmailAddress{value: $value}';
  }
}

String validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  /// if regex matches input string return input else throw exception
  if (RegExp(emailRegex).hasMatch(input)) {
    return input;
  } else {
    throw InvalidEmailException(failedValue: input);
  }
}

/// Custom exception to handle invalid email input
class InvalidEmailException implements Exception {
  final String failedValue;

  InvalidEmailException({required this.failedValue});
}

/// the throw exception problem
void check() {
  try {
    EmailAddressV1('input');
  } on InvalidEmailException catch (e) {
    /// handle exception
    log(e.toString());
  }
}
