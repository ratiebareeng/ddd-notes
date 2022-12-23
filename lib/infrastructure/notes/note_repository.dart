import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/notes/i_note_repository.dart';
import 'package:ddd_notes/domain/notes/note.dart';
import 'package:ddd_notes/domain/notes/note_failure.dart';
import 'package:ddd_notes/infrastructure/core/firestore_helpers.dart';
import 'package:ddd_notes/infrastructure/notes/note_dtos.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/transformers.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Future<Either<NoteFailure, Unit>> createNote(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final NoteDTO noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message != null && e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        log(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> deleteNote(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();

      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message != null && e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message != null && e.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        log(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> updateNote(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final NoteDTO noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message != null && e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message != null && e.message!.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        log(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    // each user has their own collection of notes
    // root collection user has individual users and their list of notes:
    // users/{user_id}/notes/{note_id}
    final userDoc = await _firestore.userDocument();
    userDoc.noteCollection
        .orderBy('servetTimeStamp', descending: true)
        .snapshots()
        .map(
          (event) => right<NoteFailure, KtList<Note>>(
            event.docs
                .map((noteDoc) => NoteDTO.fromFirestore(noteDoc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((e, stackTrace) {
      if (e is PlatformException &&
          e.message != null &&
          e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        log(e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    userDoc.noteCollection
        .orderBy('servetTimeStamp', descending: true)
        .snapshots()
        .map(
          // convert docsnapshot to note entities
          (event) => event.docs.map(
            (noteDoc) => NoteDTO.fromFirestore(noteDoc).toDomain(),
          ),
        )
        .map(
          // filter the notes from above and get only uncompleted ones
          (notes) => right<NoteFailure, KtList<Note>>(
            notes
                .where(
                  (note) =>
                      note.todos.getOrCrash().any((todoItem) => !todoItem.done),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((e, stackTrace) {
      if (e is PlatformException &&
          e.message != null &&
          e.message!.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        log(e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }
}
