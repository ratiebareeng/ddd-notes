import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/notes/i_note_repository.dart';
import 'package:ddd_notes/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/notes/note.dart';

part 'note_watcher_bloc.freezed.dart';
part 'note_watcher_event.dart';
part 'note_watcher_state.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;
  NoteWatcherBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteWatcherEvent>((event, emit) {
      event.map(
        watchAllStarted: (_) async {
          emit(const NoteWatcherState.loadInProgress());
          // cancel previous stream sub
          await _noteStreamSubscription?.cancel();
          _noteStreamSubscription = _noteRepository.watchAll().listen(
                (failureOrNotes) =>
                    add(NoteWatcherEvent.notesReceived(failureOrNotes)),
              );
        },
        watchUncompletedStarted: (_) async {
          emit(const NoteWatcherState.loadInProgress());
          // cancel previous stream sub
          await _noteStreamSubscription?.cancel();
          _noteStreamSubscription =
              _noteRepository.watchUncompleted().listen((failureOrNotes) {
            add(NoteWatcherEvent.notesReceived(failureOrNotes));
          });
        },
        notesReceived: (_NotesReceived value) {
          value.failureOrNotes.fold(
            (noteFailure) => emit(NoteWatcherState.loadFailure(noteFailure)),
            (notesKtList) => emit(NoteWatcherState.loadSuccess(notesKtList)),
          );
        },
      );
    });
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
