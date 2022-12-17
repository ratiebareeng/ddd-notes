import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'failures.dart';

/// enforce only final fields in object
/// generic class to hold the boilerplate for entities
/// generics allows value of any type
@immutable
abstract class ValueObject<T> extends Equatable {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Value{$value}';
}
