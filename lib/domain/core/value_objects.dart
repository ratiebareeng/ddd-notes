import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'errors.dart';
import 'failures.dart';

/// enforce only final fields in object
/// generic class to hold the boilerplate for entities
/// generics allows value of any type
@immutable
abstract class ValueObject<T> extends Equatable {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  /// id == (r) => r
  /// identity, returning the same thing you recieve
  /// Returns valid [T] value
  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() => value.fold((f) => throw UnexpectedValueError(f), id);

  /// get whether the valueobject holds the right value
  bool isValid() => value.isRight();

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Value{$value}';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  /// generate unique id
  factory UniqueId() {
    return UniqueId._(right(const Uuid().v1()));
  }

  /// generate id from a unique string provided ex firebase uid
  factory UniqueId.fromUniqueString(String uniqueId) {
    /// trust string is unique
    return UniqueId._(right(uniqueId));
  }

  const UniqueId._(this.value);
}
