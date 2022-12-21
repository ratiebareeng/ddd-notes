import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/core/failures.dart';
import 'package:ddd_notes/domain/core/value_objects.dart';
import 'package:ddd_notes/domain/core/value_transformers.dart';
import 'package:ddd_notes/domain/core/value_validators.dart';
import 'package:kt_dart/collection.dart';

class NoteBody extends ValueObject<String> {
  const NoteBody._(this.value);
  static const maxLength = 1000;
  @override
  final Either<ValueFailure<String>, String> value;

  factory NoteBody(String input) {
    /*   return NoteBody._(
      validateMaxStringLength(input, maxLength)
          // takes in value from first func (str)
          .flatMap(
        (valueFromPrevFun) => validateStringNotEmpty(valueFromPrevFun),
      ),
    ); */
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }
}

class TodoName extends ValueObject<String> {
  const TodoName._(this.value);
  static const maxLength = 30;
  @override
  final Either<ValueFailure<String>, String> value;

  factory TodoName(String input) {
    return TodoName._(
      validateMaxStringLength(input, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateSingleLine),
    );
  }
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xFFFAFAFA), // canvas
    Color(0xFFFFD54F), // amber.300
    Color(0xFF616161), // grey 700
    Color(0xFF8D6E63), // brown 400
    Color(0xFFEF9A9A), // red 200
    Color(0xFF81C784), // green accent 300
    Color(0xFFFFFDD0), // cream
  ];
  const NoteColor._(this.value);
  static const maxLength = 30;
  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor(Color input) {
    return NoteColor._(right(makeColorOpaque(input)));
  }
}

class ListThree<T> extends ValueObject<KtList<T>> {
  const ListThree._(this.value);
  static const maxLength = 3;
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  factory ListThree(KtList<T> input) {
    return ListThree._(
      validateMaxListLength(input, maxLength),
    );
  }

  int get length => value.getOrElse(() => emptyList()).size;

  bool get isFull => length == maxLength;
}
