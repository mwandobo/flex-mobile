
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_service.dart';

class AuthService {

  Future<(bool, String)> login(String email, String password) async {
    final response = await ApiService().post('/login', data: {
      'email': email,
      'password': password,
    });

    final token = response['user']['token'] as String;
    final id = response['user']['id'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setBool('isLoggedIn', true);
    ApiService().updateToken(token);
    return (true, 'Login successful');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.setBool('isLoggedIn', false);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
