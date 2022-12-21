import 'package:ddd_notes/domain/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/core/value_objects.dart';

extension FirebaseUserDomainX on User {
  AppUser toDomain() {
    return AppUser(id: UniqueId.fromUniqueString(uid));
  }
}
