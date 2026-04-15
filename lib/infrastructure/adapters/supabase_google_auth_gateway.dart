import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/app_config.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/services/auth_gateway.dart';

class SupabaseGoogleAuthGateway implements AuthGateway {
  SupabaseGoogleAuthGateway();

  GoogleSignIn? _googleSignIn;
  static const _demoUser = AppUser(
    id: 'local-demo-parent',
    role: UserRole.parent,
    displayName: 'admin (demo)',
    email: 'admin@local.demo',
  );

  @override
  Future<AppUser?> restoreCurrentUser() async {
    if (!AppConfig.hasSupabaseConfig) {
      return null;
    }

    final user = Supabase.instance.client.auth.currentUser;
    return _mapSupabaseUser(user);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    if (!AppConfig.hasSupabaseConfig) {
      return _demoUser;
    }
    if (!AppConfig.hasGoogleClientConfig) {
      throw StateError(
        'Google Sign-In is not configured. Pass GOOGLE_IOS_CLIENT_ID and GOOGLE_WEB_CLIENT_ID via --dart-define.',
      );
    }

    final signIn = _googleSignIn ??= GoogleSignIn(
      clientId: AppConfig.googleIosClientId,
      serverClientId: AppConfig.googleWebClientId,
    );

    final googleUser = await signIn.signIn();
    if (googleUser == null) {
      throw StateError('Google sign-in was cancelled by the user.');
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError(
        'Google access token was not returned. Verify GIDServerClientID / GOOGLE_WEB_CLIENT_ID configuration.',
      );
    }
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google ID token was not returned.');
    }

    final response = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user ?? Supabase.instance.client.auth.currentUser;
    final mapped = _mapSupabaseUser(user);
    if (mapped == null) {
      throw StateError('Supabase user session could not be established.');
    }
    return mapped;
  }

  @override
  Future<void> signOut() async {
    if (AppConfig.hasSupabaseConfig) {
      await Supabase.instance.client.auth.signOut();
    }
    await _googleSignIn?.signOut();
  }

  AppUser? _mapSupabaseUser(User? user) {
    if (user == null) {
      return null;
    }

    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return AppUser(
      id: user.id,
      role: UserRole.parent,
      displayName: metadata['full_name'] as String? ?? metadata['name'] as String?,
      email: user.email,
    );
  }
}
