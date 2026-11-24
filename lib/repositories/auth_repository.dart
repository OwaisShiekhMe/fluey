import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/auth/role_factory.dart';
import '../core/auth/role_strategy.dart';
import '../services/api_client.dart';

class AuthSession {
  final String token;
  final String id;
  final String email;
  final RoleStrategy roleStrategy;

  const AuthSession({
    required this.token,
    required this.id,
    required this.email,
    required this.roleStrategy,
  });
}

class AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage storage;

  AuthRepository({
    required this.apiClient,
    required this.storage,
  });

  Future<AuthSession> login({
    required String email,
    required String password,
    String mode = 'super_admin',
  }) async {
    final data = await apiClient.post(
      '/auth/login',
      withAuth: false,
      body: {
        'email': email.trim(),
        'password': password,
        'mode': mode,
      },
    );

    final token = (data['token'] ?? '').toString();
    final user = (data['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    if (token.isEmpty) {
      throw ApiException('Authentication token missing from server response.');
    }

    await storage.write(key: ApiClient.tokenKey, value: token);

    return AuthSession(
      token: token,
      id: user['id']?.toString() ?? '',
      email: user['email']?.toString() ?? email.trim(),
      roleStrategy: RoleFactory.fromApiRole(user['role']?.toString()),
    );
  }

  Future<AuthSession?> restoreSession() async {
    final token = await storage.read(key: ApiClient.tokenKey);
    if (token == null || token.isEmpty) return null;

    try {
      final data = await apiClient.get('/auth/me', withAuth: true);
      final user = (data['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

      return AuthSession(
        token: token,
        id: user['id']?.toString() ?? '',
        email: user['email']?.toString() ?? '',
        roleStrategy: RoleFactory.fromApiRole(user['role']?.toString()),
      );
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: ApiClient.tokenKey);
  }
}