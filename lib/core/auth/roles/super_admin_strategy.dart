// lib/core/auth/roles/super_admin_strategy.dart
import 'package:flutter/material.dart';
import '../role_strategy.dart';
import '../user_role.dart';

class SuperAdminStrategy implements RoleStrategy {
  @override
  UserRole get role => UserRole.superAdmin;

  @override
  String get label => 'Super Admin';

  @override
  String get defaultLoginMode => 'super_admin';

  @override
  Widget buildHomeScreen() => const SuperAdminDashboardScreen();

  @override
  bool canManageCenters() => true;

  @override
  bool canManageStaff() => true;

  @override
  bool canViewAdmissions() => true;
}

class CenterOwnerStrategy implements RoleStrategy {
  @override
  UserRole get role => UserRole.centerOwner;

  @override
  String get label => 'Center Owner';

  @override
  String get defaultLoginMode => 'user';

  @override
  Widget buildHomeScreen() => const CenterOwnerDashboardScreen();

  @override
  bool canManageCenters() => false;

  @override
  bool canManageStaff() => true;

  @override
  bool canViewAdmissions() => true;
}

class AdminStrategy implements RoleStrategy {
  @override
  UserRole get role => UserRole.admin;

  @override
  String get label => 'Admin';

  @override
  String get defaultLoginMode => 'user';

  @override
  Widget buildHomeScreen() => const AdminDashboardScreen();

  @override
  bool canManageCenters() => false;

  @override
  bool canManageStaff() => false;

  @override
  bool canViewAdmissions() => true;
}

// Placeholder dashboard widgets
class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Super Admin Dashboard')));
}

class CenterOwnerDashboardScreen extends StatelessWidget {
  const CenterOwnerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Center Owner Dashboard')));
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Admin Dashboard')));
}