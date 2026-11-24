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

    final payload = <String, dynamic>{
      'centerName': centerName.trim(),
      'primaryContactName': primaryContactName.trim(),
      'countryCode': normalizedCountryCode,
      'mobileNumber': normalizedMobile,
      'email': email.trim(),
      if (address != null && address.trim().isNotEmpty)
        'address': address.trim(),
    };

    final response = await apiClient.post(
      '/centers',
      body: payload,
      withAuth: true,
    );

    final rawData =
        (response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return CenterRegisterResult(
      message: (response['message'] ?? 'Center registered successfully')
          .toString(),
      center: Center.fromJson(rawData),
    );
  }
}