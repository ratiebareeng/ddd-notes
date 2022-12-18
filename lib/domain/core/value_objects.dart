import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
