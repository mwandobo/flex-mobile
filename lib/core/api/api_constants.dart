class ApiConstants {
  static const String baseUrl = 'http://192.168.1.124:8000/api/';

  static const Map<String, dynamic> defaultHeaders = {
    "Content-Type": "application/json",
    // Add other default headers (e.g., auth token)
  };

  // API Endpoints (for reference, not hardcoded in ApiService)
  static const String goalEndpoint = "/goal.php";
  static const String interestEndpoint = "/interest.php";
  static const String userEndpoint = "/user.php";


}