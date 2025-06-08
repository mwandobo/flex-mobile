class ApiConstants {
  static const String baseUrl = 'http://192.168.1.124:8000/api/';

  static const Map<String, dynamic> defaultHeaders = {
    "Content-Type": "application/json",
  };

  // API Endpoints
  static const String loginEndpoint = "/login";


  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}