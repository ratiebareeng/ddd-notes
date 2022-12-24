import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/notes/i_note_repository.dart';
import 'package:ddd_notes/domain/notes/note_failure.dart';
import 'package:ddd_notes/domain/notes/value_objects.dart';
import 'package:ddd_notes/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/notes/note.dart';

part 'note_form_bloc.freezed.dart';
part 'note_form_event.dart';
part 'note_form_state.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;
  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>((event, emit) {
      event.map(
        initialized: (e) {
          if (e.note != null) {
            emit(
              state.copyWith(
                note: e.note!,
                isEditing: true,
              ),
            );
          }
        },
        bodyChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(body: NoteBody(e.body)),
              // clear out any previous failures
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        colorChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(color: NoteColor(e.color)),
              // clear out any previous failures
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        todosChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                todos: ListThree(
                  e.todos.map(
                    (primitiveTodoItem) => primitiveTodoItem.toDomain(),
                  ),
                ),
              ),
              // clear out any previous failures
              saveFailureOrSuccessOption: none(),
            ),
          );
        },
        saved: (e) async {
          Either<NoteFailure, Unit>? failureOrSuccess;
          emit(
            state.copyWith(
              isSaving: true,
              saveFailureOrSuccessOption: none(),
            ),
          );
          if (state.note.failureOption.isNone()) {
            failureOrSuccess = state.isEditing
                ? await _noteRepository.updateNote(state.note)
                : await _noteRepository.createNote(state.note);
          }
          emit(
            state.copyWith(
              isSaving: false,
              showErrorMessages: true,
              saveFailureOrSuccessOption: optionOf(failureOrSuccess),
            ),
          );
        },
      );
    });
  }
}
