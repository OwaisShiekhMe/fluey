// lib/core/auth/role_strategy.dart
import 'package:flutter/material.dart';
import 'user_role.dart';

abstract class RoleStrategy {
  UserRole get role;
  String get label;
  String get defaultLoginMode; // e.g., 'super_admin' vs 'user'
  Widget buildHomeScreen();

  bool canManageCenters() => false;
  bool canManageStaff() => false;
  bool canViewAdmissions() => false;
}