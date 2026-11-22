import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage storage;

  static const String tokenKey = 'fluey_auth_token';

  ApiClient({
    required String baseUrl,
    required this.storage,
    Dio? dioOverride,
  }) : dio = dioOverride ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final skipAuth = options.extra['skipAuth'] == true;
              if (!skipAuth) {
                final token = await storage.read(key: tokenKey);
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }
              handler.next(options);
            },
          ),
        );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        path,
        data: body ?? {},
        options: Options(extra: {'skipAuth': !withAuth}),
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(extra: {'skipAuth': !withAuth}),
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ApiException _mapDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic> && responseData['message'] != null) {
      return ApiException(
        responseData['message'].toString(),
        statusCode: statusCode,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Connection timed out. Please try again.',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection or server unreachable.',
          statusCode: statusCode,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          'Server error ($statusCode).',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          error.message ?? 'Unexpected network error.',
          statusCode: statusCode,
        );
    }
  }
}