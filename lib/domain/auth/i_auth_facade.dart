import 'package:dartz/dartz.dart';
import 'package:ddd_notes/domain/auth/auth_failure.dart';
import 'package:ddd_notes/domain/auth/user.dart';
import 'package:ddd_notes/domain/auth/value_objects.dart';

/// facade is a design pattern used to connect
/// 2 or more classes with wierd interfaces you can't use
/// takes these and plugs them into a unified interface
abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required EmailAddress email, required Password password});

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required EmailAddress email, required Password password});

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Option<AppUser> getSignedInUser();

  Future<void> signOut();
}
