import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;
  String? _cachedToken;
  static const _publicPaths = ['/login', '/register'];
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.headers = ApiConstants.defaultHeaders;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(LogInterceptor(request: true, responseBody: true));
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for public paths
        if (!_publicPaths.contains(options.path)) {
          options.headers['Authorization'] = 'Bearer ${await _getToken()}';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Handle token expiration (e.g., logout or refresh)
        }
        return handler.next(error);
      },
    );
  }

  Future<String?> _getToken() async {
    return _cachedToken ??= await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('token'));
  }

  void updateToken(String? newToken) {
    _cachedToken = newToken;
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<dynamic> request(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(method: method, headers: customHeaders),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling (same as before)
  dynamic _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // Check if error format matches expected validation error structure
      if (responseData is Map && responseData['error'] is Map) {
        final errorMap = responseData['error'] as Map;

        final errorMessages = errorMap.values
            .whereType<List>()
            .expand((messages) => messages)
            .whereType<String>()
            .join(', ');
        return ApiException(statusCode, errorMessages);
      }

      return ApiException(statusCode, responseData);
    } else {
      return ApiException(0, 'Network error: ${e.message}');
    }
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final dynamic message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';

  String getErrorMessage() {
    if (message is String) return message;

    if (message is Map<String, dynamic>) {
      if (message['message'] != null) return message['message'].toString();

      if (message['error'] is String) return message['error'];

      if (message['error'] is Map) {
        final fieldErrors = message['error'] as Map;
        final errorMessages = fieldErrors.values
            .expand((v) => v is List ? v : [v])
            .map((e) => e.toString())
            .toList();
        return errorMessages.join(', ');
      }
    }

    return 'An unknown error occurred';
  }
}
