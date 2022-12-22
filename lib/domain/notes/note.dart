import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/core/failures.dart';
import 'package:ddd_notes/domain/core/value_objects.dart';
import 'package:ddd_notes/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import 'todo_item.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();
  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required ListThree<TodoItem> todos,
  }) = _Note;

  factory Note.initial() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors.first),
        todos: ListThree(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    // 1st check is body empty
    return body.failureOrUnit
        // 2nd check if list.size is not > maxLength
        .andThen(todos.failureOrUnit)
        // 3rd check todo item body multiline or empty
        .andThen(
          todos
              // get the KtList of todo items
              .getOrCrash()
              // getting failure from todo item
              .map((todoItem) => todoItem.failureOption)
              // get failures in list
              .filter((p0) => p0.isSome())
              // if !can get first item in failures list no failures exist
              .getOrElse(0, (_) => none())
              .fold(
                () => right(unit), // ifNone
                (f) => left(f), // ifSome
              ),
        )
        .fold(
          (f) => some(f),
          (_) => none(),
        );
  }
}
