import '../models/app_user.dart';

abstract class AuthGateway {
  Future<AppUser?> restoreCurrentUser();

  Future<AppUser> signInWithGoogle();

  Future<void> signOut();
}
