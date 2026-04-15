import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.role,
    this.displayName,
    this.email,
  });

  final String id;
  final UserRole role;
  final String? displayName;
  final String? email;
}
