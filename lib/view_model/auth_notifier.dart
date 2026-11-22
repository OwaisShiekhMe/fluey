import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/providers.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final AuthSession? session;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.session,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthSession? session,
    String? error,
    bool clearSession = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      session: clearSession ? null : (session ?? this.session),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> login({
    required String email,
    required String password,
    String mode = 'super_admin',
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(authRepositoryProvider);
      final session = await repo.login(
        email: email,
        password: password,
        mode: mode,
      );

      state = state.copyWith(
        isLoading: false,
        session: session,
        clearError: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> checkExistingSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final session = await repo.restoreSession();
      state = state.copyWith(
        isLoading: false,
        session: session,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState();
  }
}