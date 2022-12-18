import 'package:ddd_notes/domain/core/failures.dart';

/// used to crash the app

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;
  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const String errorMessage =
        'Encountered a ValueFailure at unrecoverable point. Terminating.';

    /// The conversion is guaranteed to not throw, so it won't use the object's toString method except for specific known and trusted types.
    return Error.safeToString('$errorMessage Failure: $valueFailure');
  }
}
