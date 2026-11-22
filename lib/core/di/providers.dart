import 'package:flutter/foundation.dart';
import 'package:fluey/view_model/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../repositories/auth_repository.dart';
import '../../services/api_client.dart';


/// Base API URL provider.
/// Switch between local/emulator dev and your Railway production URL.
final baseUrlProvider = Provider<String>((ref) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://192.168.100.186:5000';
  }
  return 'http://localhost:5000';
  // return 'https://your-fluey-backend.up.railway.app/api';
});

/// Secure token storage provider.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Dio-backed API client provider with automatic Bearer token injection.
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUrl: ref.watch(baseUrlProvider),
    storage: ref.watch(secureStorageProvider),
  );
  ref.onDispose(client.dio.close);
  return client;
});

/// Authentication repository provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

/// Riverpod 2.0 NotifierProvider for authentication state & actions.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
); 