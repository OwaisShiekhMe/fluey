// lib/core/auth/role_factory.dart
import 'roles/super_admin_strategy.dart';
import 'role_strategy.dart';
import 'user_role.dart';

class RoleFactory {
  RoleFactory._();

  static RoleStrategy create(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return SuperAdminStrategy();
      case UserRole.centerOwner:
        return CenterOwnerStrategy();
      case UserRole.admin:
        return AdminStrategy();
    }
  }

  static RoleStrategy fromApiRole(String? roleString) {
    final parsedRole = UserRole.fromString(roleString);
    return create(parsedRole);
  }
}