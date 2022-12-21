/* /// sign in helper
Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
  Emitter emitter,
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
 */