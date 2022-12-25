import 'package:auto_route/auto_route.dart';
import 'package:ddd_notes/application/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: ((context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            context.router.replaceNamed('/notes-overview-page');
          },
          unAuthenticated: (_) {
            AutoRouter.of(context).replaceNamed('/sign-in-page');
          },
        );
      }),
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
