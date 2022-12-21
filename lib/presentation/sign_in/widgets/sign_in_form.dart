import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ddd_notes/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  SignInForm({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {}, // if none
          (either) => either.fold(
            (failure) {
              FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Sign in cancelled',
                  serverError: (_) => 'Server error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) =>
                      'Invalid email and password combination',
                ),
              ).show(context);
            },
            (_) {
              // TODO: navigate
            }, // right of either
          ),
        );
      },
      builder: (context, state) {
        final signInBloc = context.read<SignInFormBloc>();
        return Form(
          key: _formKey,
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 70,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  signInBloc.add(
                    SignInFormEvent.emailChanged(value),
                  );
                },
                validator: (_) {
                  /// we are already validating email with its valueobject
                  /// so we show
                  /// state from the builder is delayed updated
                  /// so we use state from context
                  return signInBloc.state.emailAddress.value.fold(
                    (f) => f.maybeMap(
                      invalidEmail: (_) => 'Invalid Email',
                      orElse: () => null,
                    ),
                    (r) => null,
                  );
                  // return 'Inv E';
                  // return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                onChanged: (value) {
                  signInBloc.add(
                    SignInFormEvent.passwordChanged(value),
                  );
                },
                validator: (_) {
                  return signInBloc.state.password.value.fold(
                    (f) => f.maybeMap(
                      shortPassword: (_) => 'Short Password',
                      orElse: () => null,
                    ),
                    (r) => null,
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        signInBloc.add(
                          const SignInFormEvent
                              .signInWithEmailAndPasswordPressed(),
                        );
                      },
                      child: Text(
                        'Sign In'.toUpperCase(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        signInBloc.add(
                          const SignInFormEvent
                              .registerWithEmailAndPasswordPressed(),
                        );
                      },
                      child: Text(
                        'Register'.toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: (() {
                  signInBloc.add(
                    const SignInFormEvent.signInWithGooglePressed(),
                  );
                }),
                child: Text(
                  'Sign In With Google'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(
                  height: 8.0,
                ),
                const LinearProgressIndicator(
                  value: null, // none deterministic
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
