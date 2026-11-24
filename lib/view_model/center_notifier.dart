import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/providers.dart';
import '../model/center.dart';
import '../repositories/center_repository.dart';

class CenterState {
  final bool isLoading;
  final bool isFetchingCenters;
  final List<Center> activeCenters;
  final String? error;
  final String? fetchError;
  final CenterRegisterResult? lastRegistered;

  const CenterState({
    this.isLoading = false,
    this.isFetchingCenters = false,
    this.activeCenters = const <Center>[],
    this.error,
    this.fetchError,
    this.lastRegistered,
  });

  CenterState copyWith({
    bool? isLoading,
    bool? isFetchingCenters,
    List<Center>? activeCenters,
    String? error,
    String? fetchError,
    CenterRegisterResult? lastRegistered,
    bool clearError = false,
    bool clearFetchError = false,
    bool clearLastRegistered = false,
  }) {
    return CenterState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingCenters: isFetchingCenters ?? this.isFetchingCenters,
      activeCenters: activeCenters ?? this.activeCenters,
      error: clearError ? null : (error ?? this.error),
      fetchError: clearFetchError ? null : (fetchError ?? this.fetchError),
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

  Future<void> fetchActiveCenters() async {
    state = state.copyWith(
      isFetchingCenters: true,
      clearFetchError: true,
    );

    try {
      final repo = ref.read(centerRepositoryProvider);
      final centers = await repo.getActiveCenters();

      state = state.copyWith(
        isFetchingCenters: false,
        activeCenters: centers,
        clearFetchError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isFetchingCenters: false,
        fetchError: e.toString(),
      );
    }
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

      final updatedCenters = <Center>[
        result.center,
        ...state.activeCenters,
      ];

      state = state.copyWith(
        isLoading: false,
        lastRegistered: result,
        activeCenters: updatedCenters,
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