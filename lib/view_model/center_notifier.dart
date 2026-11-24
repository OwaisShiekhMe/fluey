import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/providers.dart';
import '../repositories/center_repository.dart';

class CenterState {
  final bool isLoading;
  final String? error;
  final CenterRegisterResult? lastRegistered;

  const CenterState({
    this.isLoading = false,
    this.error,
    this.lastRegistered,
  });

  CenterState copyWith({
    bool? isLoading,
    String? error,
    CenterRegisterResult? lastRegistered,
    bool clearError = false,
    bool clearLastRegistered = false,
  }) {
    return CenterState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      lastRegistered:
          clearLastRegistered ? null : (lastRegistered ?? this.lastRegistered),
    );
  }
}

class CenterNotifier extends Notifier<CenterState> {
  @override
  CenterState build() {
    return const CenterState();
  }

  Future<bool> registerCenter({
    required String centerName,
    required String primaryContactName,
    required String countryCode,
    required String mobileNumber,
    required String email,
    String? address,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearLastRegistered: true,
    );

    try {
      final repo = ref.read(centerRepositoryProvider);
      final result = await repo.registerCenter(
        centerName: centerName,
        primaryContactName: primaryContactName,
        countryCode: countryCode,
        mobileNumber: mobileNumber,
        email: email,
        address: address,
      );

      state = state.copyWith(
        isLoading: false,
        lastRegistered: result,
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

  void clearStatus() {
    state = const CenterState();
  }
}