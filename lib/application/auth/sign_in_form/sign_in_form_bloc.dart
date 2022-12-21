import 'dart:developer';

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/auth/i_auth_facade.dart';
import 'package:ddd_notes/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/auth/auth_failure.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormState get initialState => SignInFormState.initial();

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<RegisterWithEmailAndPasswordPressed>(
        _registerWithEmailAndPasswordPressed);
    on<SignInWithEmailAndPasswordPressed>(_signInWithEmailAndPasswordPressed);
    on<SignInWithGooglePressed>(_signInWithGooglePressed);
  }

  void _emailChanged(
    EmailChanged event,
    Emitter emitter,
  ) {
    emitter(
      state.copyWith(
        // pass in email string from event
        emailAddress: EmailAddress(event.email),
        // reset the response
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  void _passwordChanged(
    PasswordChanged event,
    Emitter emitter,
  ) {
    emitter(
      state.copyWith(
        password: Password(event.password),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  void _registerWithEmailAndPasswordPressed(
    RegisterWithEmailAndPasswordPressed event,
    Emitter emitter,
  ) async {
    /// TODO: Code duplication: fix _performActionOnAuthFacadeWithEmailAndPassword
    /*  _performActionOnAuthFacadeWithEmailAndPassword(
      _authFacade.registerWithEmailAndPassword,
    ); */
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    /// 1. check if given emailaddress and password are valid
    if (isEmailValid && isPasswordValid) {
      /// 2. if valid register using iauthfacade and yield some(right<unit>) in authfailureorsuccess

      failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
        email: state.emailAddress,
        password: state.password,
      );
    }
    log('_registerWithEmailAndPasswordPressed ${failureOrSuccess.toString()}');

    /// 3. if invalid, show error messages and set authfailureorsuccess as none()
    emitter(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }

  void _signInWithEmailAndPasswordPressed(
    SignInWithEmailAndPasswordPressed event,
    Emitter emitter,
  ) async {
    /*    log('why');
    _performActionOnAuthFacadeWithEmailAndPassword(
        emitter, _authFacade.signInWithEmailAndPassword); */
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    /// 1. check if given emailaddress and password are valid
    if (isEmailValid && isPasswordValid) {
      /// 2. if valid register using iauthfacade and yield some(right<unit>) in authfailureorsuccess

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
        email: state.emailAddress,
        password: state.password,
      );
    }
    log('_signInWithEmailAndPasswordPressed ${failureOrSuccess.toString()}');

    /// 3. if invalid, show error messages and set authfailureorsuccess as none()
    emitter(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }

  void _signInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emitter(state.copyWith(
      isSubmitting: false,
      authFailureOrSuccessOption: some(failureOrSuccess),
    ));
  }

  /*  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    yield* event.map(
      emailChanged: (e) async* {
        yield state.copyWith(
          // pass in email string from event
          emailAddress: EmailAddress(e.email),
          // reset the response
          authFailureOrSuccessOption: none(),
        );
      },
      passwordChanged: (e) async* {
        yield state.copyWith(
          password: Password(e.password),
          authFailureOrSuccessOption: none(),
        );
      },
      registerWithEmailAndPasswordPressed: (e) async* {
        yield* _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async* {
        yield* _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.signInWithEmailAndPassword);
      },
      signInWithGooglePressed: (e) async* {
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        );
        final failureOrSuccess = await _authFacade.signInWithGoogle();
        yield state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        );
      },
    );
  } */

  /// sign in helper
  /* Future<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function(
            {required EmailAddress email, required Password password})
        forwardedCall,
  ) async {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    /// 1. check if given emailaddress and password are valid
    if (isEmailValid && isPasswordValid) {
      /// 2. if valid register using iauthfacade and yield some(right<unit>) in authfailureorsuccess

      failureOrSuccess = await forwardedCall(
        email: state.emailAddress,
        password: state.password,
      );
    }
    log('_performActionOnAuthFacadeWithEmailAndPassword ${failureOrSuccess.toString()}');
    // log('after emit ${state.toString()}');

    /// 3. if invalid, show error messages and set authfailureorsuccess as none()

    return state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  } */
}
