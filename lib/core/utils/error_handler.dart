import 'package:flex_mobile/core/api/api_service.dart';

class ErrorHandler {
  static String handle(dynamic e) {
    if (e is ApiException) {
      return e.getErrorMessage();
    }

    print('Unexpected error: $e');
    return 'An unexpected error occurred';
  }
}
