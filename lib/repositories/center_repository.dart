import '../model/center.dart';
import '../services/api_client.dart';

class CenterRegisterResult {
  final String message;
  final Center center;

  const CenterRegisterResult({
    required this.message,
    required this.center,
  });
}

class CenterRepository {
  final ApiClient apiClient;

  CenterRepository({required this.apiClient});

  Future<List<Center>> getActiveCenters() async {
    final response = await apiClient.get(
      '/centers',
      withAuth: true,
    );

    final rawList = response['data'];
    if (rawList is! List) {
      return const <Center>[];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(Center.fromJson)
        .toList();
  }

  Future<CenterRegisterResult> registerCenter({
    required String centerName,
    required String primaryContactName,
    required String countryCode,
    required String mobileNumber,
    required String email,
    String? address,
  }) async {
    final normalizedCountryCode = countryCode.replaceAll(RegExp(r'\s+'), '');
    final normalizedMobile =
        mobileNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final trimmedAddress = address?.trim();

    final payload = <String, dynamic>{
      'centerName': centerName.trim(),
      'primaryContactName': primaryContactName.trim(),
      'countryCode': normalizedCountryCode,
      'mobileNumber': normalizedMobile,
      'email': email.trim(),
      if (trimmedAddress != null && trimmedAddress.isNotEmpty)
        'address': trimmedAddress,
    };

    final response = await apiClient.post(
      '/centers',
      body: payload,
      withAuth: true,
    );

    final rawData = response['data'];
    final centerJson = rawData is Map<String, dynamic>
        ? rawData
        : <String, dynamic>{};

    return CenterRegisterResult(
      message: (response['message'] ?? 'Center registered successfully')
          .toString(),
      center: Center.fromJson(centerJson),
    );
  }
}
