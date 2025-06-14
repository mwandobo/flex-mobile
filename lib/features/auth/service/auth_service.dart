import 'dart:convert';

import 'package:flex_mobile/core/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_service.dart';
import '../models/user_model.dart';

class AuthService {
  Future<(bool, String)> login(String email, String password) async {
    final response = await ApiService()
        .request(ApiConstants.post, ApiConstants.loginEndpoint, data: {
      'email': email,
      'password': password,
    });

    final userJson = response['user'];
    final user = UserModel.fromJson(userJson);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setBool('isLoggedIn', true);
    ApiService().updateToken(user.token);

    // final token = response['user']['token'] as String;
    // final id = response['user']['id'];
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('userId', id);
    // await prefs.setBool('isLoggedIn', true);
    // ApiService().updateToken(token);
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
