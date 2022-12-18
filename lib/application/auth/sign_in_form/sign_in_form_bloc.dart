import 'package:bloc/bloc.dart';
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

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial());

  @override
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
        yield* _performActionOnAuthFaacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async* {
        yield* _performActionOnAuthFaacadeWithEmailAndPassword(
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
  }

  /// sign in helper
  Stream<SignInFormState> _performActionOnAuthFaacadeWithEmailAndPassword(
    //SignInFormEvent event,
    Future<Either<AuthFailure, Unit>> Function(
            {required EmailAddress email, required Password password})
        forwardedCall,
  ) async* {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    /// 1. check if given emailaddress and password are valid
    if (isEmailValid && isPasswordValid) {
      /// 2. if valid register using iauthfacade and yield some(right<unit>) in authfailureorsuccess
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );
      failureOrSuccess = await forwardedCall(
        email: state.emailAddress,
        password: state.password,
      );
    }

    /// 3. if invalid, show error messages and set authfailureorsuccess as none()
    yield state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
