// lib/core/auth/user_role.dart
enum UserRole {
  superAdmin('super_admin'),
  centerOwner('center_owner'),
  admin('admin');

  final String apiValue;
  const UserRole(this.apiValue);

  static UserRole fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'super_admin':
        return UserRole.superAdmin;
      case 'center_owner':
        return UserRole.centerOwner;
      case 'admin':
        return UserRole.admin;
      default:
        throw ArgumentError('Unknown user role: $value');
    }
  }
}