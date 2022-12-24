part of 'note_form_bloc.dart';

@freezed
class NoteFormEvent with _$NoteFormEvent {
  // null if we're creating a new note
  const factory NoteFormEvent.initialized(Note? note) = _Initialized;
  const factory NoteFormEvent.bodyChanged(String body) = _BodyChanged;
  const factory NoteFormEvent.colorChanged(Color color) = _ColorChanged;
  const factory NoteFormEvent.todosChanged(KtList<TodoItemPrimitive> todos) =
      _TodosChanged;
  // event for both creating and updating an existing note
  const factory NoteFormEvent.saved() = _Saved;
}
