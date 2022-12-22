import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/notes/note.dart';
import 'package:ddd_notes/domain/notes/note_failure.dart';
import 'package:kt_dart/collection.dart';

abstract class INoteRepository {
  // watch notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  // watch uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  // Create note
  Future<Either<NoteFailure, Unit>> createNote(Note note);
  // Update note
  Future<Either<NoteFailure, Unit>> updateNote(Note note);

  // Delete note
  Future<Either<NoteFailure, Unit>> deleteNote(Note note);
}
