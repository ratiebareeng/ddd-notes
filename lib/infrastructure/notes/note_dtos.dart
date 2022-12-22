import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ddd_notes/domain/core/value_objects.dart';
import 'package:ddd_notes/domain/notes/todo_item.dart';
import 'package:ddd_notes/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/notes/note.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDTO implements _$NoteDTO {
  const NoteDTO._();
  const factory NoteDTO({
    @JsonKey(ignore: true) String? id,
    required String body,
    required int color,
    required List<TodoItemDTO> todos,
    // Sentinel values that can be used when writing document fields with set() or update().
    @TimestampConverter() required FieldValue servetTimeStamp,
  }) = _NoteDTO;

  factory NoteDTO.fromDomain(Note note) {
    return NoteDTO(
      id: note.id.getOrCrash(),
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .asList()
          .map((todoItem) => TodoItemDTO.fromDomain(todoItem))
          .toList(),
      servetTimeStamp: FieldValue.serverTimestamp(),
    );
  }

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(id!),
      body: NoteBody(body),
      color: NoteColor(Color(color)),
      todos: ListThree(
        todos.map((todoItemDTO) => todoItemDTO.toDomain()).toImmutableList(),
      ),
    );
  }

  factory NoteDTO.fromFirestore(DocumentSnapshot noteDoc) {
    return NoteDTO.fromJson(noteDoc.data() as Map<String, dynamic>).copyWith(
      id: noteDoc.id,
    );
  }

  factory NoteDTO.fromJson(Map<String, dynamic> json) =>
      _$NoteDTOFromJson(json);
}

class TimestampConverter implements JsonConverter<FieldValue, Object> {
  // if you want to use a class an annotation you need to have a const constructor
  const TimestampConverter();

  @override
  FieldValue fromJson(Object json) => FieldValue.serverTimestamp();

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
abstract class TodoItemDTO implements _$TodoItemDTO {
  const TodoItemDTO._();

  const factory TodoItemDTO({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDTO;

  factory TodoItemDTO.fromDomain(TodoItem todoItem) {
    return TodoItemDTO(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDTO.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDTOFromJson(json);
}
