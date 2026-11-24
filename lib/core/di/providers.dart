import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../repositories/auth_repository.dart';
import '../../repositories/center_repository.dart';
import '../../services/api_client.dart';
import '../../view_model/auth_notifier.dart';
import '../../view_model/center_notifier.dart';

/// Base API URL provider.
///
/// • Android emulator   → http://10.0.2.2:5000/api
/// • Physical device     → http://<your-PC-IP>:5000/api  (same Wi-Fi)
/// • iOS simulator       → http://localhost:5000/api
/// • Windows desktop     → http://localhost:5000/api
/// • Production          → https://your-fluey-backend.up.railway.app/api
final baseUrlProvider = Provider<String>((ref) {
  // Using your machine's Wi-Fi IP so it works on both emulators & physical devices
  return 'http://192.168.100.186:5000/api';
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

/// Center repository provider.
final centerRepositoryProvider = Provider<CenterRepository>((ref) {
  return CenterRepository(apiClient: ref.watch(apiClientProvider));
});

/// Riverpod 2.0 NotifierProvider for center registration & state.
final centerProvider = NotifierProvider<CenterNotifier, CenterState>(
  CenterNotifier.new,
);
